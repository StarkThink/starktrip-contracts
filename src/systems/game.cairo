use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

#[starknet::interface]
trait IGame<TContractState> {
    fn create_game(
        ref self: TContractState, world: IWorldDispatcher, player_name: felt252
    ) -> felt252;
    fn move(ref self: TContractState, world: IWorldDispatcher, pos_x: u32, pos_y: u32) -> u32;
}

#[starknet::contract]
mod game {
    use super::IGame;
    use dojo::world::IWorldDispatcher;
    use starktrip::store::{Store, StoreTrait};
    use starktrip::game::GameTrait;
    use starktrip::board::BoardTrait;
    use starktrip::spaceship::SpaceshipTrait;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl Game of IGame<ContractState> {
        #[inline(always)]
        fn create_game(
            ref self: ContractState, world: IWorldDispatcher, player_name: felt252
        ) -> u32 {
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

            let game = GameTrait::new();

            game_id
        }

        #[inline(always)]
        fn move(ref self: ContractState, world: IWorldDispatcher, pos_x: u32, pos_y: u32) -> u32 {
            pos_x
        }
    }
}
