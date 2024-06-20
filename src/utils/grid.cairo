use dojo::world::{IWorld, IWorldDispatcher, IWorldDispatcherTrait};
use starktrip::utils::random::{Random, RandomImpl};
use core::fmt::{Display, Formatter, Error};

#[derive(Clone, Copy, PartialEq, Drop, Display)]
enum Cell {
    Empty,
    Wall,
    Alien,
    Alien2,
    Ghost,
    Dino,
    AlienPlanet,
    Alien2Planet,
    GhostPlanet,
    DinoPlanet,
}

impl CellDisplay of Display<Cell> {
    fn fmt(self: @Cell, ref f: Formatter) -> Result<(), Error> {
        let s: felt252 = match self {
            Cell::Empty => 1,
            Cell::Wall => 2,
            Cell::Alien => 3,
            Cell::Alien2 => 4,
            Cell::Ghost => 5,
            Cell::Dino => 6,
            Cell::AlienPlanet => 7,
            Cell::Alien2Planet => 8,
            Cell::GhostPlanet => 9,
            Cell::DinoPlanet => 10,
        };
        write!(f, "{s}")
    }
}

impl CellIntoFelt252 of Into<Cell, felt252> {
    fn into(self: Cell) -> felt252 {
        match self {
            Cell::Empty => 1,
            Cell::Wall => 2,
            Cell::Alien => 3,
            Cell::Alien2 => 4,
            Cell::Ghost => 5,
            Cell::Dino => 6,
            Cell::AlienPlanet => 7,
            Cell::Alien2Planet => 8,
            Cell::GhostPlanet => 9,
            Cell::DinoPlanet => 10,
        }
    }

}

#[generate_trait]
impl CellImpl of CellTrait {
    fn random(world: IWorldDispatcher) -> Cell {
        let mut randomizer = RandomImpl::new(world);
        let random_number = randomizer.between::<u32>(0, 9);
        match random_number {
            0 => Cell::Empty,
            1 => Cell::Wall,
            2 => Cell::Alien,
            3 => Cell::Alien2,
            4 => Cell::Ghost,
            5 => Cell::Dino,
            6 => Cell::AlienPlanet,
            7 => Cell::Alien2Planet,
            8 => Cell::GhostPlanet,
            9 => Cell::DinoPlanet,
            _ => Cell::Wall, // default case, should not happen
        }
    }
}

fn get_cell_at(map: Span<Cell>, len_cols: u8, row: u8, col: u8) -> Cell {
    let index: u32 = ((row * len_cols) + col).into();
    *map.at(index)
}

fn should_paint_wall(row: u8, col: u8, ref randomizer: Random) -> bool {
    if row % 2 != 0 && col % 2 != 0 {
        return true;
    }
    if row % 2 == 0 && col % 2 == 0 {
        return false;
    }
    randomizer.bool()
}

fn get_row(map: Span<Cell>, len_cols: u8, row: u8) -> Array<Cell> {
    let index: u32 = ((row * len_cols)).into();
    let mut row = array![];
    let mut i = 0_u32;
    loop {
        if i == len_cols.into() {
            break;
        }
        row.append(*map.at(index + i));
        i += 1_u32;
    };
    row
}

fn get_matrix_index(len_cols: u8, row: u8, col: u8) -> u32 {
    ((row * len_cols) + col).into()
}

fn check_row_for_trapped_empty(map: Span<Cell>, len_cols: u8, len_rows: u8, row: u8 ) -> Array<u32> {
    let mut row_below = ArrayTrait::<Cell>::new();
    let mut result = ArrayTrait::<u32>::new();
    if len_rows > row + 1 {
        row_below = get_row(map, len_cols, row + 1);
    }
    let mut row_above = ArrayTrait::<Cell>::new();
    if row > 0 {
        row_below = get_row(map, len_cols, row - 1);
    }

    let mut current_row = get_row(map, len_cols, row);
    let mut i = 0_u8;
    let mut empty_found = false;
    let mut trapped_empty = true;
    let mut trapped_start_index = 0;
    let mut index_to_update = 0_u8;
    loop {
        if *current_row.at(i.into()) == Cell::Empty {
            if empty_found == false {
                trapped_start_index = i;
            }
            empty_found = true;
            if row_below.len() > 0 && *row_below.at(i.into()) == Cell::Empty {
                trapped_empty = false;
            } else if row_above.len() > 0 && *row_above.at(i.into()) == Cell::Empty {
                trapped_empty = false;
            } else {
             trapped_empty = true;
            }
        }
        if ((i+1) == len_cols) || *current_row.at(i.into()) == Cell::Wall {
            index_to_update = i;
            if trapped_empty && empty_found {
                // We should only modify walls if one of index x, or y is not even.
                if index_to_update % 2 == 0 && row % 2 == 0 {
                    if index_to_update > 0 && (index_to_update - 1) >= trapped_start_index {
                        index_to_update -= 1;
                    }
                }
                if row_below.len() > 0 {
                    result.append(get_matrix_index(len_cols: len_cols, row: row + 1, col: index_to_update));
                } else if row_above.len() > 0 {
                    result.append(get_matrix_index(len_cols: len_cols, row: row - 1, col: index_to_update));
                }
            }
            empty_found = false;
            if ((i+1) == len_cols) {
                break;
            }
        }
        i += 1;
    };
    result
}

fn generate_map(world: IWorldDispatcher, rows: u8, cols: u8) -> Array<Cell> {
    let mut map: Array<Cell> = ArrayTrait::new();
    let mut randomizer = RandomImpl::new(world);
    
    let mut x_index = 0;
    loop {
        if x_index == rows {
            break;
        }
        let mut y_index = 0;
        loop {
            if y_index == cols {
                break;
            }
            let wall = should_paint_wall(row: x_index, col: y_index, ref randomizer: randomizer);
            if wall {
                map.append(Cell::Wall);
            } else {
                map.append(Cell::Empty);
            }
            y_index += 1;
        };
        x_index += 1;
    };

    x_index = 0;
    let mut index_to_update = array![];
    let mut map_span = map.span();
    loop{
        if x_index == rows {
            break;
        }
        let mut index_to_update_row = check_row_for_trapped_empty(map_span, cols, rows, x_index);
        loop {
            if index_to_update_row.len() == 0 {
                break;
            }
            let index = index_to_update_row.pop_front().unwrap();
            let index_felt: felt252 = index.into();
            println!("Index: {}", index_felt);
            index_to_update.append(index);
        };
        x_index += 1;
    };

    let mut result: Array<Cell> = ArrayTrait::new();
    let mut map_index = 0;
    loop{
        if map_index == map.len() {
            break;
        }
        let mut index_aux = 0;
        let mut value_to_store = *map.at(map_index);
        let mut index_to_update_span = index_to_update.span();
        loop {
            if index_aux == index_to_update_span.len() {
                break;
            }
            if *index_to_update_span.at(index_aux) == map_index {
                value_to_store = Cell::Empty;
            }
            index_aux += 1;
        };
        map_index += 1;
        result.append(value_to_store);
    };
    // let characters = [
    //     Cell::Alien,
    //     Cell::Alien2,
    //     Cell::Ghost,
    //     Cell::Dino,
    //     Cell::AlienPlanet,
    //     Cell::Alien2Planet,
    //     Cell::GhostPlanet,
    //     Cell::DinoPlanet,
    // ];
    
    
    // for &character in &characters {
    //     let mut placed = false;
    //     while !placed {
    //         let row = rng.gen_range(0..rows);
    //         let col = rng.gen_range(0..cols);
    //         if !placed_characters.contains(&(row, col)) && map[row][col] != Cell::Wall {
    //             map[row][col] = character;
    //             placed_characters.insert((row, col));
    //             placed = true;
    //         }
    //     }
    // }
    
    // // Ensure each empty/character/planet space has at least one adjacent wall
    // for row in 0..rows {
    //     for col in 0..cols {
    //         if map[row][col] != Cell::Wall && !has_adjacent_wall(&map, row, col) {
    //             let adjacent_positions = get_adjacent_positions(rows, cols, row, col);
    //             for (adj_row, adj_col) in adjacent_positions {
    //                 if map[adj_row][adj_col] == Cell::Wall {
    //                     continue;
    //                 } else {
    //                     map[adj_row][adj_col] = Cell::Wall;
    //                     break;
    //                 }
    //             }
    //         }
    //     }
    // }
    
    result
}

// fn has_adjacent_wall(map: &Vec<Vec<Cell>>, row: usize, col: usize) -> bool {
//     let adjacent_positions = get_adjacent_positions(map.len(), map[0].len(), row, col);
//     adjacent_positions.iter().any(|&(adj_row, adj_col)| map[adj_row][adj_col] == Cell::Wall)
// }

// fn get_adjacent_positions(rows: usize, cols: usize, row: usize, col: usize) -> Vec<(usize, usize)> {
//     let mut positions = Vec::new();
//     if row > 0 { positions.push((row - 1, col)); }
//     if row < rows - 1 { positions.push((row + 1, col)); }
//     if col > 0 { positions.push((row, col - 1)); }
//     if col < cols - 1 { positions.push((row, col + 1)); }
//     positions
// }
