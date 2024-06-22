mod grid_test {
    use starktrip::utils::grid::generate_map;
    use starktrip::tests::utils::printMap;
    use starktrip::utils::grid::{Cell, CellDisplay, CellIntoFelt252};
    use starktrip::utils::maps::get_random_hardcoded_map;

    use starktrip::tests::setup::setup;
    #[test]
    #[available_gas(30000000000000000)]
    fn test_grid() {
        let (world, _) = setup::spawn_game();
        let (map, _, size) = get_random_hardcoded_map(world, 1);
        let rows = *size.at(0);
        let columns = *size.at(1);
        printMap(map, rows, columns);
    }
}
