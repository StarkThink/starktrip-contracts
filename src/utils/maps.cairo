use starktrip::utils::grid::Cell;
use starktrip::utils::random::RandomImpl;
use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};

fn get_map(round: u8, map_index: u8) -> (Array<Cell>, u8, Array<u8>) {
    let map_1 = (
        array![Cell::Empty, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::DinoPlanet, Cell::Blank, Cell::Blank, Cell::Wall, Cell::GhostPlanet,
            Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
            Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty], 7_u8, array![5_u8, 5_u8]
    ); // 7


    let map_2 = (
        array![Cell::Alien, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::AlienPlanet, Cell::Wall, Cell::Blank, Cell::Wall, Cell::LazyBearPlanet,
            Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
            Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty], 7_u8, array![5_u8, 5_u8]
    ); // 7

    let map_3 = (
        array![Cell::Robot, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::RobotPlanet, Cell::Blank, Cell::Empty], 5_u8, array![5_u8, 5_u8]
    ); // 5

    let map_4 = (
        array![Cell::GhostPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::RobotPlanet, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot, Cell::Blank, Cell::Empty,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty], 9_u8, array![5_u8, 9_u8]
    ); // 9

    let map_5 = (
        array![Cell::Alien, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 11_u8, array![5_u8, 9_u8]
    ); // 11

    let map_6 = (
        array![Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 6_u8, array![5_u8, 9_u8]
    ); // 6

    let map_7 = (
        array![Cell::Empty, Cell::Wall, Cell::Dino, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Robot, Cell::Blank, Cell::RobotPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::GhostPlanet], 12_u8, array![7_u8, 11_u8]
    ); // 12

    let map_8 = (
        array![Cell::Dino, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Robot, Cell::Wall, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::RobotPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 15_u8, array![7_u8, 11_u8]
    ); // 15

    let map_9 = (
        array![Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBearPlanet, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Alien2Planet, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 12_u8, array![7_u8, 11_u8]
    ); // 12

    let map_10 = (
        array![Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Ghost, Cell::Wall, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2Planet, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Robot], 12_u8, array![5_u8, 7_u8]
    ); // 12

    let map_11 = (
        array![Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::GhostPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::AlienPlanet, Cell::Blank, Cell::Alien, Cell::Wall, Cell::Blank, Cell::Blank, Cell::DinoPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Dino, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty], 11_u8, array![5_u8, 7_u8]
); // 11

    let map_12 = (
        array![Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Ghost, Cell::Blank, Cell::RobotPlanet,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Robot], 10_u8, array![5_u8, 7_u8]
    ); // 10

    let map_13 = (
        array![Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::AlienPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Dino, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty], 15_u8, array![7_u8, 11_u8]
    ); // 15

    let map_14 = (
        array![Cell::GhostPlanet, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::RobotPlanet, Cell::Wall, Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Robot, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall,
        Cell::Empty, Cell::Wall, Cell::DinoPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Dino, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Ghost, Cell::Wall, Cell::Empty], 15_u8, array![7_u8, 11_u8]
    ); // 15

    let map_15 = (
        array![Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Wall, Cell::RobotPlanet, Cell::Blank, Cell::Alien2Planet, Cell::Blank, Cell::LazyBear,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::AlienPlanet, Cell::Wall, Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty, Cell::Wall, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Robot, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Empty], 21_u8, array![7_u8, 11_u8]
    ); // 21

    let map_16 = (
        array![Cell::AlienPlanet, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::RobotPlanet, Cell::Blank, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2Planet, Cell::Blank, Cell::LazyBear, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien2, Cell::Blank, Cell::Empty, Cell::Blank, Cell::Alien, Cell::Blank, Cell::Ghost], 16_u8, array![5_u8, 7_u8]
); // 16

    let map_17 = (
        array![Cell::Alien, Cell::Blank, Cell::GhostPlanet, Cell::Wall, Cell::AlienPlanet, Cell::Blank, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Ghost, Cell::Blank, Cell::Alien2, Cell::Blank, Cell::Blank, Cell::Wall, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Robot, Cell::Blank, Cell::LazyBearPlanet, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 13_u8, array![5_u8, 7_u8]
    ); // 13

    let map_18 = (
        array![Cell::Robot, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Alien, Cell::Wall, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::AlienPlanet, Cell::Wall, Cell::Ghost, Cell::Blank, Cell::Blank, Cell::Blank, Cell::Empty,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBear, Cell::Blank, Cell::Alien2, Cell::Wall, Cell::Alien2Planet, Cell::Blank, Cell::LazyBearPlanet], 14_u8, array![5_u8, 7_u8]
    ); // 14

    let map_19 = (
        array![Cell::Empty, Cell::Blank, Cell::DinoPlanet, Cell::Blank, Cell::RobotPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Dino, Cell::Wall, Cell::Blank, Cell::Blank, Cell::Robot,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::LazyBearPlanet, Cell::Blank, Cell::LazyBear, Cell::Wall, Cell::Empty], 8_u8, array![5_u8, 5_u8]
    ); // 8

    let map_20 = (
        array![Cell::Empty, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::AlienPlanet,
        Cell::Wall, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Ghost, Cell::Blank, Cell::Blank, Cell::Wall, Cell::LazyBearPlanet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Alien, Cell::Blank, Cell::Empty, Cell::Blank, Cell::LazyBear], 7_u8, array![5_u8, 5_u8]
); // 7

    let map_21 = (
        array![Cell::Ghost, Cell::Blank, Cell::GhostPlanet, Cell::Blank, Cell::Alien2Planet,
        Cell::Blank, Cell::Wall, Cell::Blank, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::Blank, Cell::Blank, Cell::LazyBearPlanet,
        Cell::Wall, Cell::Wall, Cell::Wall, Cell::Wall, Cell::Blank,
        Cell::Empty, Cell::Blank, Cell::LazyBear, Cell::Blank, Cell::Alien2], 8_u8, array![5_u8, 5_u8]
    ); // 8


    if round == 1 {
        if map_index == 1 {
            map_1
        }

        else if map_index == 2 {
            map_2
        }

        else {
            map_3
        }
        
    }

    else if round == 2 {
        if map_index == 1 {
            map_4
        }

        else if map_index == 2 {
            map_5
        }

        else {
            map_6
        }
        
    }

    else if round == 3 {
        if map_index == 1 {
            map_7
        }

        else if map_index == 2 {
            map_8
        }

        else {
            map_9
        }
        
    }

    else if round == 4 {
        if map_index == 1 {
            map_10
        }

        else if map_index == 2 {
            map_11
        }

        else {
            map_12
        }
        
    }

    else if round == 5 {
        if map_index == 1 {
            map_13
        }

        else if map_index == 2 {
            map_14
        }

        else {
            map_15
        }
        
    }

    else if round == 6 {
        if map_index == 1 {
            map_16
        }

        else if map_index == 2 {
            map_17
        }

        else {
            map_18
        }
        
    }

    else {
        if map_index == 1 {
            map_19
        }

        else if map_index == 2 {
            map_20
        }

        else {
            map_21
        }
        
    }
}

fn get_random_hardcoded_map(world: IWorldDispatcher, round: u8) -> (Array<Cell>, u8, Array<u8>) {
    let mut randomizer = RandomImpl::new(world);
    let mut random_index = randomizer.between::<u8>(0, 2);

    let (map, gas_solution, matrix_size) = get_map(round, random_index);
    (map, gas_solution, matrix_size)
}