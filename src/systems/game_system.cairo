use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> u32;
    fn move(game_id: u32, pos_x: u8, pos_y: u8);
    fn create_round(game_id: u32);
    fn end_game(game_id: u32);
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;
    use starktrip::models::game::{Game, GameTrait};
    use starktrip::models::board::{Board, BoardTrait};
    use starktrip::models::spaceship::{Spaceship, SpaceshipTrait};
    use starktrip::models::leader_board::{LeaderBoard, LeaderBoardTrait};
    use starktrip::models::leader_board_players::{LeaderBoardPlayers, LeaderBoardPlayersTrait};
    use starktrip::models::characters_inside::{CharactersInside, CharactersInsideTrait};
    use starktrip::models::events::{GameOver, GameWin, CreateGame, GameEvent, Move};
    use starktrip::models::tile::Tile;
    use starktrip::store::{Store, StoreTrait};
    use starktrip::utils::grid::{generate_map, Cell, CellIntoFelt252, CellTrait,};
    use starktrip::utils::maps::get_random_hardcoded_map;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> u32 {
            let mut store = StoreTrait::new(world);

            let game_id = world.uuid() + 1;
            let (map, gas, size) = get_random_hardcoded_map(world, 1);
            let rows = *size.at(0);
            let columns = *size.at(1);
            self.store_map(game_id, ref store, @map, rows, columns);

            let max_movements = gas;
            let board = self.generate_board(game_id, @map, rows, columns, max_movements);

            let spaceship = self.generate_spaceship(game_id, @map, rows, columns, max_movements);
            let mut leader_board = store.get_leader_board(1);
            if leader_board.len_players == 0 {
                leader_board = self.generate_leaderboard();
            }

            let owner = get_caller_address();

            let game = GameTrait::new(
                id: game_id,
                owner: owner,
                player_name: player_name,
                score: 0,
                round: 1,
                active: true
            );

            store.set_game(game);
            store.set_board(board);
            store.set_spaceship(spaceship);
            store.set_leader_board(leader_board);

            let CreateGameEvent = CreateGame { game_id: game_id, player_address: owner };
            emit!(world, (CreateGameEvent));

            game_id
        }

        fn move(world: IWorldDispatcher, game_id: u32, pos_x: u8, pos_y: u8) {
            let mut store: Store = StoreTrait::new(world);

            let mut game: Game = store.get_game(game_id);
            let mut spaceship = store.get_spaceship(game_id);
            let mut board = store.get_board(game_id);
            let cell = self.get_cell_at(ref store, game_id, pos_x.into(), pos_y.into());

            assert(game.active, 'Game is not active');

            if spaceship.remaining_gas == 0 {
                self.end_game_proc(world, game_id);
                ()
            }

            if cell != Cell::Blank {
                spaceship.remaining_gas -= 1;
            }

            if cell.is_character() && !self.character_inside(game_id, spaceship, ref store, cell) {
                store
                    .set_characters_inside(
                        CharactersInside {
                            id: spaceship.len_characters_inside.into(),
                            game_id: game_id,
                            value: cell.into()
                        }
                    );
                spaceship.len_characters_inside += 1;
            }

            if cell.is_planet() {
                let character_removed = self
                    .remove_character_for_planet(game_id, spaceship, ref store, cell);
                if character_removed {
                    // since we removed a character, we need to update the spaceship
                    spaceship = store.get_spaceship(game_id);
                    board.remaining_characters -= 1;
                }
            }

            if board.remaining_characters == 0 {
                game.score += 10;
                let GameWinEvent = GameWin {
                    game_id: game_id,
                    player_address: get_caller_address(),
                    round: game.round,
                    score: game.score
                };
                emit!(world, (GameWinEvent));
                store.set_game(game);
                ()
            }

            let moveEvent = Move {
                game_id: game_id,
                pos_x: pos_x,
                pos_y: pos_y,
                remaining_gas: spaceship.remaining_gas,
                max_movements: board.max_movements,
                len_characters_inside: spaceship.len_characters_inside
            };
            emit!(world, (moveEvent));
            store.set_spaceship(spaceship);
            store.set_board(board);
            ()
        }

        fn create_round(world: IWorldDispatcher, game_id: u32) {
            let mut store: Store = StoreTrait::new(world);
            
            let mut game = store.get_game(game_id);

            game.round += 1;
            
            if game.round <= 7 {
                let gameEvent = GameEvent { id: game_id, score: game.score, round: game.round };
                emit!(world, (gameEvent));
            } else {
                let GameOverEvent = GameOver {
                    game_id: game_id, player_address: get_caller_address()
                };
                emit!(world, (GameOverEvent));
            }

            let (map, gas, size) = get_random_hardcoded_map(world, game.round);
            let rows = *size.at(0);
            let columns = *size.at(1);

            self.store_map(game_id, ref store, @map, rows, columns);

            let max_movements = gas;
            let board = self.generate_board(game_id, @map, rows, columns, max_movements);
            store.set_board(board);

            let spaceship = self.generate_spaceship(game_id, @map, rows, columns, max_movements);
            store.set_spaceship(spaceship);
            store.set_game(game);

        }

        fn end_game(world: IWorldDispatcher, game_id: u32) {
            self.end_game_proc(world, game_id);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn store_map(
            self: @ContractState,
            game_id: u32,
            ref store: Store,
            map: @Array<Cell>,
            rows: u8,
            cols: u8
        ) {
            let mut x_index = 0;
            loop {
                if x_index == rows {
                    break;
                }
                let mut y_index = 0;
                loop {
                    if y_index == cols {
                        break;
                    }
                    let cell = *map.at((x_index * cols + y_index).into());
                    store
                        .set_tile(
                            Tile {
                                row_id: x_index.into(),
                                col_id: y_index.into(),
                                game_id: game_id,
                                value: cell.into()
                            }
                        );
                    y_index += 1;
                };
                x_index += 1;
            };
        }

        fn felt252_to_cell(self: @ContractState, value: felt252) -> Cell {
            let mut result = Cell::Empty;
            if value == 'empty' {
                result = Cell::Empty;
            } else if value == 'wall' {
                result = Cell::Wall;
            } else if value == 'alien' {
                result = Cell::Alien;
            } else if value == 'alien2' {
                result = Cell::Alien2;
            } else if value == 'ghost' {
                result = Cell::Ghost;
            } else if value == 'dino' {
                result = Cell::Dino;
            } else if value == 'alien_p' {
                result = Cell::AlienPlanet;
            } else if value == 'alien2_p' {
                result = Cell::Alien2Planet;
            } else if value == 'ghost_p' {
                result = Cell::GhostPlanet;
            } else if value == 'dino_p' {
                result = Cell::DinoPlanet;
            } else if value == 'player' {
                result = Cell::Player;
            } else if value == 'lazybear' {
                result = Cell::LazyBear;
            } else if value == 'lazybear_p' {
                result = Cell::LazyBearPlanet;
            } else if value == 'robot' {
                result = Cell::Robot;
            } else if value == 'robot_p' {
                result = Cell::RobotPlanet;
            } else if value == 'blank' {
                result = Cell::Blank;
            } else {
                result = Cell::Wall;
            }
            result
        }

        fn get_cell_at(
            self: @ContractState, ref store: Store, game_id: u32, row_id: u32, col_id: u32
        ) -> Cell {
            let tile = store.get_tile(row_id, col_id, game_id);
            self.felt252_to_cell(tile.value)
        }

        fn generate_board(
            self: @ContractState,
            game_id: u32,
            map: @Array<Cell>,
            rows: u8,
            cols: u8,
            max_movements: u8
        ) -> Board {
            let mut i = 0_u8;
            let mut characters_inside = 0;
            loop {
                if i.into() == map.len() {
                    break;
                }
                let cell = *map.at(i.into());
                if cell.is_character() {
                    characters_inside += 1;
                }
                i += 1;
            };
            Board {
                game_id: game_id,
                len_rows: rows,
                len_cols: cols,
                max_movements: max_movements,
                remaining_characters: characters_inside
            }
        }

        fn generate_spaceship(
            self: @ContractState,
            game_id: u32,
            map: @Array<Cell>,
            rows: u8,
            cols: u8,
            remaining_gas: u8
        ) -> Spaceship {
            let mut i = 0_u8;
            let mut x = 0;
            let mut y = 0;
            loop {
                if i.into() == map.len() {
                    break;
                }
                let cell = *map.at(i.into());
                if cell == Cell::Player {
                    x = i / cols;
                    y = i % cols;
                    break;
                }
                i += 1;
            };
            Spaceship {
                game_id: game_id,
                pos_x: x,
                pos_y: y,
                remaining_gas: remaining_gas,
                len_characters_inside: 0
            }
        }

        fn generate_leaderboard(self: @ContractState) -> LeaderBoard {
            LeaderBoard { id: 1, len_players: 0 }
        }

        fn get_characters_inside(
            self: @ContractState, game_id: u32, spaceship: Spaceship, ref store: Store
        ) -> Array<Cell> {
            let mut i = 0;
            let mut result = array![];
            loop {
                if i == spaceship.len_characters_inside {
                    break;
                }
                let character = store.get_characters_inside(id: i.into(), game_id: game_id);
                result.append(self.felt252_to_cell(character.value));
                i += 1;
            };
            result
        }

        fn character_inside(
            self: @ContractState,
            game_id: u32,
            spaceship: Spaceship,
            ref store: Store,
            character: Cell
        ) -> bool {
            let characters = self.get_characters_inside(game_id, spaceship, ref store);
            let mut i = 0;
            let result = loop {
                if i == characters.len() {
                    break false;
                }
                let character_inside = *characters.at(i.into());
                if character == character_inside {
                    break true;
                }
                i += 1;
            };
            result
        }

        fn remove_character_inside(
            self: @ContractState,
            game_id: u32,
            mut spaceship: Spaceship,
            ref store: Store,
            character: Cell
        ) {
            let mut i = 0;
            loop {
                if i == spaceship.len_characters_inside {
                    break;
                }
                let character_found = store.get_characters_inside(id: i.into(), game_id: game_id);
                if self.felt252_to_cell(character_found.value) == character {
                    if i < (spaceship.len_characters_inside - 1) {
                        // Move the last element to the current position
                        let mut last_character = store
                            .get_characters_inside(
                                id: (spaceship.len_characters_inside - 1).into(), game_id: game_id
                            );
                        last_character.id = i.into();
                        store.set_characters_inside(last_character);
                    }
                    spaceship.len_characters_inside -= 1;
                    store.set_spaceship(spaceship);
                    break;
                }
                i += 1;
            };
        }

        fn remove_character_for_planet(
            self: @ContractState,
            game_id: u32,
            mut spaceship: Spaceship,
            ref store: Store,
            planet: Cell
        ) -> bool {
            let characters = self.get_characters_inside(game_id, spaceship, ref store);
            let mut i = 0;
            let result = loop {
                if i == characters.len() {
                    break false;
                }
                let character = *characters.at(i.into());
                if character.get_character_planet() == planet {
                    self.remove_character_inside(game_id, spaceship, ref store, character);
                    break true;
                }
                i += 1;
            };
            result
        }

        fn end_game_proc(self: @ContractState, world: IWorldDispatcher, game_id: u32) {
            let mut store: Store = StoreTrait::new(world);
            let mut game: Game = store.get_game(game_id);
            let mut leader_board: LeaderBoard = store.get_leader_board(1);

            game.active = false;

            let new_player: LeaderBoardPlayers = LeaderBoardPlayersTrait::new(
                leader_board.len_players, game.player_name, game.score
            );
            leader_board.len_players += 1;

            store.set_leader_board_players(new_player);
            store.set_leader_board(leader_board);
            store.set_game(game);

            let GameOverEvent = GameOver { game_id: game_id, player_address: get_caller_address() };
            emit!(world, (GameOverEvent));
        }
    }
}
