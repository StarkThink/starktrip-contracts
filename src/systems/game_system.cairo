use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> u32;
    fn move(node_id: u32, id: u32);
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;
    use starktrip::models::game::{Game, GameTrait};
    use starktrip::models::board::{Board, BoardTrait};
    use starktrip::models::spaceship::{Spaceship, SpaceshipTrait};
    use starktrip::events::{GameOver, GameWin, CreateGame};
    use starktrip::store::{Store, StoreTrait};
    use starknet::{get_caller_address, get_contract_address};

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> u32 {
            let mut store = StoreTrait::new(world);

            let game_id = world.uuid() + 1;

            let board = BoardTrait::new(
                id: 1,
                root: 'root',
                children: ArrayTrait::<u32>::new(),
                game_id: game_id,
                max_movements: 0,
                animals_to_deliver: 0
            );

            let spaceship = SpaceshipTrait::new(
                id: 1, game_id: game_id, node_id: 1, movements: 0, delivered_animals: 0
            );

            let owner = get_contract_address();

            let game = GameTrait::new(
                id: game_id,
                spaceship_id: spaceship.id,
                board_id: board.id,
                score: 0,
                round: 1,
                player_name: player_name,
                owner: owner,
                state: true
            );

            store.set_game(game);
            store.set_board(board);
            store.set_spaceship(spaceship);

            ///TODO: Add create game event

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
                    game_id: id, player_address: get_caller_address(), round: round, score: score
                };
                emit!(world, (GameWinEvent));

                let CreateGameEvent = CreateGame {
                    game_id: id, player_address: get_caller_address()
                };
                emit!(world, (CreateGameEvent));
            }
        }
    }
}
