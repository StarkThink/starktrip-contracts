use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

#[dojo::interface]
trait IGameSystem {
    fn create_game(player_name: felt252) -> felt252;
    fn move(node_id: u32) -> u32;
}

#[dojo::contract]
mod game_system {
    use super::IGameSystem;

    #[abi(embed_v0)]
    impl GameImpl of IGameSystem<ContractState> {
        fn create_game(world: IWorldDispatcher, player_name: felt252) -> felt252 {
            player_name
        }

        fn move(world: IWorldDispatcher, node_id: u32) -> u32 {
            node_id
        }
    }
}
