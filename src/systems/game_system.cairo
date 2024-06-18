use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> felt252;
    fn move(id: u32);
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;
    use starktrip::models::game::Game;
    use starktrip::models::board::Board;
    use starktrip::models::spaceship::Spaceship;
    use starktrip::models::events::{GameOver, GameWin, CreateGame};
    use starktrip::store::{Store, StoreTrait};
    use starknet::get_caller_address;

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> felt252 {
            player_name
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
