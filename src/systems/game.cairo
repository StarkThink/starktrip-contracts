use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

#[starknet::interface]
trait IGame<TContractState> {
    fn create_game(ref self: TContractState, world: IWorldDispatcher, player_name: felt252) -> felt252;
    fn move(ref self: TContractState, world: IWorldDispatcher, pos_x: u32, pos_y: u32) -> u32;
}

#[starknet::contract]
mod game {
    use super::IGame;
    use dojo::world::IWorldDispatcher;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl Game of IGame<ContractState> {
        #[inline(always)]
        fn create_game(ref self: ContractState, world: IWorldDispatcher, player_name: felt252) -> felt252 {
            player_name
        }

        #[inline(always)]
        fn move(ref self: ContractState, world: IWorldDispatcher, pos_x: u32, pos_y: u32) -> u32 {
            pos_x
        }
    }
}
