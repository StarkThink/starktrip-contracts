use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> felt252;
    fn move(node_id: u32) -> u32;
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;
    use starktrip::store::{Store, StoreTrait};
    use starktrip::game::GameTrait;
    use starktrip::board::BoardTrait;
    use starktrip::spaceship::SpaceshipTrait;
    use starknet::get_contract_address;
    use starktrip::events::CreateGame;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CreateGame: CreateGame,
    }

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> u32 {
            let mut store = StoreTrait::new(world);

            let game_id = world.uuid();

            let board = BoardTrait::new(
                id: 1,
                root: 'root',
                children: '',
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

        fn move(world: IWorldDispatcher, node_id: u32) -> u32 {
            node_id
        }
    }
}
