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
    use starktrip::events::{GameOver, GameWin, CreateGame};
    use starktrip::store::{Store, StoreTrait};
    use starknet::get_caller_address;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        GameOver: GameOver,
        GameWin: GameWin,
        CreateGame: CreateGame
    }

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> u32 {
            let mut store = StoreTrait::new(world);

            let game_id = world.uuid() + 1;

            let board = BoardTrait::new(
                id: 1,
                root: 'root',
                children: Vec::new(),
                game_id,
                max_movements: 0,
                animamals_to_deliver: 0
            );
            let spaceship = SpaceshipTrait::new(
                id: 1, game_id, node_id: 1, movements: 0, delivered_animals: 0
            );
            let owner = get_contract_address();
            let game = GameTrait::new(
                game_id,
                spaceship_id: spaceship.id,
                board_id: board.id,
                score: 0,
                round: 1,
                player_name,
                owner,
                state: true
            );
            let _event = CreateGame { game_id, owner };
            emit!(world, (Event::CreateGame(_event)));

            game_id
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

            let caller = get_caller_address();

            if movements <= max_movements {
                movements += 1;
            } else {
                let _event = GameOver { game_id: id, player_address: caller };
                emit!(world, (Event::GameOver(_event)));
            }

            let mut round = game.round;
            let mut score = game.score;

            let mut delivered_animals = spaceship.delivered_animals;
            let animals_to_deliver = board.animals_to_deliver;

            if delivered_animals == animals_to_deliver {
                let _event = GameWin {
                    game_id: id, player_address: caller, round: round, score: score
                };
                emit!(world, (Event::GameWin(_event)));

                let _event = CreateGame { game_id: id, player_address: caller };
                emit!(world, (Event::CreateGame(_event)));
            }
        }
    }
}
