mod setup {
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::ContractAddress;
    use starknet::testing::set_contract_address;

    use starktrip::systems::game_system::{game_system, IGameSystemDispatcher, IGameSystemDispatcherTrait};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use starktrip::systems::game_system::{game_system, IGameSystemDispatcher, IGameSystemDispatcherTrait};

    fn OWNER() -> ContractAddress {
        starknet::contract_address_const::<'OWNER'>()
    }

    #[derive(Drop)]
    struct Systems {
        game_system: IGameSystemDispatcher,
    }

    fn spawn_game() -> (IWorldDispatcher, Systems) {
        let models = array![];
        let world = spawn_test_world(models);
        let systems = Systems {
            game_system: IGameSystemDispatcher {
                contract_address: world
                    .deploy_contract('game_system', game_system::TEST_CLASS_HASH.try_into().unwrap()),
            }
        };
        set_contract_address(OWNER());
        (world, systems)
    }
}