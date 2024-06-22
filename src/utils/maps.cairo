use starktrip::utils::grid::Cell;
use starktrip::utils::random::RandomImpl;

fn get_map(round: u8, map_index: u8) -> (Array<Cell>, u8, Array<u8>) {
    let map_1 = array![
        array![Cell::Empty, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::DinoPlanet, Cell::Blank, Cell::Blank, Cell::Wall, Cell::GhostPlanet,
            Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
            Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty], 7, array![5, 5]
    ]; // 7


    let map_2 = array![
        array![Cell::Alien, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::AlienPlanet, Cell::Wall, Cell::Blank, Cell::Wall, Cell::LazyBearPlanet,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty], 7, array![5, 5]
    ]; // 7

    let map_3 = array![
        array![Cell::Robot, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::RobotPlanet, Cell::Blank, Cell::Empty], 5, array![5, 5]
    ]; // 5

    let map_4 = array![
        array![Cell::GhostPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::RobotPlanet, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot, Cell::Blank, Cell::Empty,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty], 9, array![5, 9]
    ]; // 9

    let map_5 = array![
        array![Cell::Alien, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 11, array![5, 9]
    ]; // 11

    let map_6 = array![
        array![Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 6, array![5, 9]
    ]; // 6

    let map_7 = array![
        array![Cell::Empty, Cell::Wall, Cell::Dino, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Robot, Cell::Blank, Cell::RobotPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::GhostPlanet], 12, array![7, 11]
    ]; // 12

    let map_8 = array![
        array![Cell::Dino, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Robot, Cell::Wall, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::RobotPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 15, array![7, 11]
    ]; // 15

    let map_9 = array![
        array![Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBearPlanet, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Alien2Planet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 12, array![7, 11]
    ]; // 12

    let map_10 = array![
        array![Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Ghost, Cell::Wall, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2Planet, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Robot], 12, array![5, 7]
    ]; // 12

    let map_11 = array![
        array![Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::GhostPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::AlienPlanet, Cell::Blank, Cell::Alien, Cell::Wall, Cell::Blank, Cell::Blank, Cell::DinoPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Dino, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty], 11, array![5, 7]
    ]; // 11

    let map_12 = array![
        array![Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::RobotPlanet,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Robot], 10, array![5, 7]
    ]; // 10

    let map_13 = array![
        array![Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Dino, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 15, array![7, 11]
    ]; // 15

    let map_14 = array![
        array![Cell::GhostPlanet, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::RobotPlanet, Cell::Wall, Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Robot, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Wall, Cell::Empty], 15, array![7, 11]
    ]; // 15

    let map_15 = array![
        array![Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::RobotPlanet, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::LazyBear,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::AlienPlanet, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Robot, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Empty], 21, array![7, 11]
    ]; // 21

    let map_16 = array![
        array![Cell::AlienPlanet, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::RobotPlanet, Cell::Blank, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2Planet, Cell::Blank, Cell::LazyBear, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Ghost], 16, array![5, 7]
    ]; // 16

    let map_17 = array![
        array![Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::AlienPlanet, Cell::Blank, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Ghost, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Robot, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 13, array![5, 7]
    ]; // 13

    let map_18 = array![
        array![Cell::Robot, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Alien, Cell::Wall, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Wall, Cell::Ghost, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBear, Cell::Blank, Cell::Alien2, Cell::Wall, Cell::Alien2Planet, Cell::Blank, Cell::LazyBearPlanet], 14, array![5, 7]
    ]; // 14

    let map_19 = array![
        array![Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Dino, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::LazyBear, Cell::Wall, Cell::Empty], 8, array![5, 5]
    ]; // 8

    let map_20 = array![
        array![Cell::Empty, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::AlienPlanet,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Ghost, Cell::Blank, Cell::Blank, Cell::Wall, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 7, array![5, 5]
    ]; // 7

    let map_21 = array![
        array![Cell::Ghost, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::LazyBearPlanet,
        Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Alien2], 8, array![5, 5]
    ]; // 8

    // // Definición de los diccionarios para cada ronda
    let d_round_1 = array![map_1, map_2, map_3];
    let d_round_2 = array![map_19, map_20, map_21];
    let d_round_3 = array![map_10, map_11, map_12];
    let d_round_4 = array![map_16, map_17, map_18];
    let d_round_5 = array![map_4, map_5, map_6];
    let d_round_6 = array![map_7, map_8, map_9];
    let d_round_7 = array![map_13, map_14, map_15];

    let rounds = array![
        d_round_1, d_round_2, d_round_3, d_round_4, d_round_5, d_round_6, d_round_7
    ];

    let round_index = *rounds.at(round);
    let map_target = *round_index.at(map_index);
    (*map_target.at(0), *map_target.at(1), *map_target.at(2))
}

fn get_random_hardcoded_map(round: u8) -> (Array<Cell>, u8, u8) {
    let mut random_index = RandomImpl::between::<u8>(0, 3);
    let (map, gas_solution, matrix_size) = get_map(round, random_index);
    let rows = *matrix_size.at(0);
    let columns = *matrix_size.at(1);
    (map, rows, columns)
}