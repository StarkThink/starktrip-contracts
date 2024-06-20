mod grid_test {

    use starktrip::utils::grid::generate_map;
    use starktrip::tests::utils::printMap;
    use starktrip::utils::grid::{Cell, CellDisplay, CellIntoFelt252};

    use starktrip::tests::setup::setup;
    #[test]
    #[available_gas(30000000000000000)]
    fn test_grid() {
        let (world, _) = setup::spawn_game();
        let map = generate_map(world, 7, 5);
        printMap(map, 7, 5);
    }
}