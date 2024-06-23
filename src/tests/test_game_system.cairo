mod test_game_system {
    use starktrip::tests::utils::printMap;
    use starktrip::utils::grid::{Cell, CellDisplay, CellIntoFelt252};
    use starktrip::utils::maps::get_random_hardcoded_map;
    use starktrip::store::{Store, StoreTrait};
    use starktrip::systems::game_system::{game_system, IGameSystemDispatcher, IGameSystemDispatcherTrait};

    use starktrip::tests::setup::setup;
    #[test]
    #[available_gas(30000000000000000)]
    fn test_move() {
        let (world, systems) = setup::spawn_game();
        let mut store: Store = StoreTrait::new(world);
        
        let game_id = systems.game_system.create_game('test');
        systems.game_system.move(game_id, 0, 0);
    }
}
