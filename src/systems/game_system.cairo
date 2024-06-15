use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> felt252;
    fn move(node_id: u32, id: u32);
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

        fn move(world: IWorldDispatcher, node_id: u32, id: u32) {
            let mut store: Store = StoreTrait::new(world);

            let game: Game = store.get_game(id);

            let spaceship_id = game.spaceship_id;
            let mut spaceship = store.get_spaceship(spaceship_id);
            spaceship.node_id = node_id;

            let mut movements = spaceship.movements;

            let board_id = game.board_id;
            let board = store.get_board(board_id);
            let max_movements = board.max_movements;

            if movements <= max_movements {
                movements += 1;
            } else {
                let GameOverEvent = GameOver { game_id: id, player_address: get_caller_address() };
                emit!(world, (GameOverEvent));
            }

            let mut round = game.round;
            let mut score = game.score;

            let mut delivered_animals = spaceship.delivered_animals;
            let animals_to_deliver = board.animals_to_deliver;

            if delivered_animals == animals_to_deliver {
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
