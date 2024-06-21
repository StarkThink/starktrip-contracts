use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> u32;
    fn move(id: u32);
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;
    use starktrip::models::game::{Game, GameTrait};
    use starktrip::models::board::{Board, BoardTrait};
    use starktrip::models::spaceship::{Spaceship, SpaceshipTrait};
    use starktrip::models::events::{GameOver, GameWin, CreateGame};
    use starktrip::models::tile::Tile;
    use starktrip::store::{Store, StoreTrait};
    use starktrip::utils::grid::{generate_map, Cell, CellIntoFelt252};
    use starknet::{get_caller_address, get_contract_address};
    

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> u32 {
            let mut store = StoreTrait::new(world);

            let game_id = world.uuid() + 1;
            let map = generate_map(world, 7, 5);
            self.store_map(game_id, ref store, @map, 7, 5);

            let board = BoardTrait::new(
                game_id: game_id,
                len_rows: 7,
                len_cols: 5,
                max_movements: 0,
                remaining_characters: 0
            );

            let spaceship = SpaceshipTrait::new(
                game_id: game_id, pos_x: 0, pos_y: 0, remaining_gas: 0, len_characters_inside: 0
            );

            let owner = get_caller_address();

            let game = GameTrait::new(
                id: game_id,
                owner: owner,
                player_name: player_name,
                score: 0,
                round: 1
            );

            store.set_game(game);
            store.set_board(board);
            store.set_spaceship(spaceship);

            let CreateGameEvent = CreateGame {
                game_id: game_id, player_address: owner
            };
            emit!(world, (CreateGameEvent));

            game_id
        }

        fn move(world: IWorldDispatcher, id: u32) {
            let mut store: Store = StoreTrait::new(world);

            let game: Game = store.get_game(id);

            let spaceship = store.get_spaceship(id);
            let mut remaining_gas = spaceship.remaining_gas;

            let board = store.get_board(id);
            let mut max_movements = board.max_movements;

            if remaining_gas <= max_movements {
                remaining_gas -= 1;
            } else {
                let GameOverEvent = GameOver { game_id: id, player_address: get_caller_address() };
                emit!(world, (GameOverEvent));
            }

            let mut round = game.round;
            let mut score = game.score;

            let mut remaining_characters = board.remaining_characters;

            if remaining_characters == 0 {
                let GameWinEvent = GameWin {
                    game_id: id, player_address: get_caller_address(), round, score
                };
                emit!(world, (GameWinEvent));

                let CreateGameEvent = CreateGame {
                    game_id: id, player_address: get_caller_address()
                };
                emit!(world, (CreateGameEvent));
            }
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn store_map(self: @ContractState, game_id: u32, ref store: Store, map: @Array<Cell>, rows: u8, cols: u8) {
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
                    store.set_tile(
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
    }
}
