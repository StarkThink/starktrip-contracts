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
    Player,
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
            Cell::Player => 11,
        };
        write!(f, "{s}")
    }
}

impl CellIntoFelt252 of Into<Cell, felt252> {
    fn into(self: Cell) -> felt252 {
        match self {
            Cell::Empty => 'empty',
            Cell::Wall => 'wall',
            Cell::Alien => 'alien',
            Cell::Alien2 => 'alien2',
            Cell::Ghost => 'ghost',
            Cell::Dino => 'dino',
            Cell::AlienPlanet => 'alien_p',
            Cell::Alien2Planet => 'alien2_p',
            Cell::GhostPlanet => 'ghost_p',
            Cell::DinoPlanet => 'dino_p',
            Cell::Player => 'player',
        }
    }
}

#[generate_trait]
impl CellImpl of CellTrait {
    fn is_character(self: Cell) -> bool {
        match self {
            Cell::Empty => false,
            Cell::Wall => false,
            Cell::Alien => true,
            Cell::Alien2 => true,
            Cell::Ghost => true,
            Cell::Dino => true,
            Cell::AlienPlanet => false,
            Cell::Alien2Planet => false,
            Cell::GhostPlanet => false,
            Cell::DinoPlanet => false,
            Cell::Player => false,
        }
    }

    fn is_planet(self: Cell) -> bool {
        match self {
            Cell::Empty => false,
            Cell::Wall => false,
            Cell::Alien => false,
            Cell::Alien2 => false,
            Cell::Ghost => false,
            Cell::Dino => false,
            Cell::AlienPlanet => true,
            Cell::Alien2Planet => true,
            Cell::GhostPlanet => true,
            Cell::DinoPlanet => true,
            Cell::Player => false,
        }
    }

    fn get_character_planet(self: Cell) -> Cell {
        match self {
            Cell::Alien => Cell::AlienPlanet,
            Cell::Alien2 => Cell::Alien2Planet,
            Cell::Ghost => Cell::GhostPlanet,
            Cell::Dino => Cell::DinoPlanet,
            _ => Cell::Empty, // should not happen
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

fn element_pending(current_elements: Span<Cell>, random_element: Cell) -> bool {
    let mut i = 0;
    let result = loop {
        if  i == current_elements.len() {
            break true;
        }
        if *current_elements.at(i) == random_element {
            break false;
        }
        i += 1;
    };
    result
}

fn get_random_element(ref randomizer: Random, current_elements: Span<Cell>) -> Cell {
    if current_elements.len() >= 9 {
        return Cell::Empty;
    }
    let mut element_placed = false;
    let random_element = loop {
        let mut random_selector = randomizer.between::<u8>(0, 10);
        if random_selector == 1 {
            continue;
        }
        let random_element = match random_selector {
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
            10 => Cell::Player,
            _ => Cell::Wall, // default case, should not happen
        };

        element_placed = element_pending(current_elements, random_element);
        if element_placed {
            break random_element;
        }
    };
    random_element
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

fn get_index_from_matrix_index(matrix_index: u8, len_cols: u8) -> (u8, u8) {
    let row: u8 = matrix_index / len_cols;
    let col: u8 = matrix_index % len_cols;
    (row.into(), col.into())
}

fn check_row_for_trapped_empty(map: Span<Cell>, len_cols: u8, len_rows: u8, row: u8 ) -> Array<u32> {
    let mut result = ArrayTrait::<u32>::new();

    let mut row_below = ArrayTrait::<Cell>::new();
    if len_rows > row + 1 {
        row_below = get_row(map, len_cols, row + 1);
    }
    let mut row_above = ArrayTrait::<Cell>::new();
    if row > 0 {
        row_above = get_row(map, len_cols, row - 1);
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
            if (row_below.len() > 0 && *row_below.at(i.into()) == Cell::Empty) 
            || (row_above.len() > 0 && *row_above.at(i.into()) == Cell::Empty) 
            {
                trapped_empty = false;
            } else {
                trapped_empty = true;
            }
        }
        if ((i+1) == len_cols) || *current_row.at(i.into()) == Cell::Wall {
            index_to_update = i;
            if trapped_empty && empty_found {
                // We should only modify walls if one of index x, or y is not even.
                if (index_to_update % 2 == 0) ^ (row % 2 == 0) {
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

fn paint_wall(world: IWorldDispatcher, rows: u8, cols: u8) -> Array<Cell> {
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
    map
}

fn generate_map(world: IWorldDispatcher, rows: u8, cols: u8) -> Array<Cell> {
    let mut randomizer = RandomImpl::new(world);

    let mut x_index = 0;
    let mut index_to_update = array![];
    let mut map = paint_wall(world, rows, cols);
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

    let mut i = 0_u8;
    let mut current_elements = array![];
    let mut matrix_with_elements = array![];
    let mut special_characters_per_line = 3_u8;
    loop {
        if i.into() == result.len() {
            break;
        }
        if i % cols == 0 {
            special_characters_per_line = 3;
        }
        let (x, y) = get_index_from_matrix_index(i, cols);
        if x % 2 == 0 && y % 2 == 0 && *result.at(i.into()) == Cell::Empty {
            let random_element = get_random_element(ref randomizer, current_elements.span());
            if random_element != Cell::Empty && special_characters_per_line > 0 {
                special_characters_per_line -= 1;
            }

            if special_characters_per_line > 0 {
                current_elements.append(random_element);
                matrix_with_elements.append(random_element);
            } else {
                matrix_with_elements.append(*result.at(i.into()));
            }
        } else {
            matrix_with_elements.append(*result.at(i.into()));
        }
        i += 1;
    };

    let player_not_placed = element_pending(current_elements.span(), Cell::Player);
    if player_not_placed {
        i = 0;
        let mut matrix_with_player = array![];
        let mut player_placed = false;
        loop {
            if i.into() == matrix_with_elements.len() {
                break;
            }
            if *matrix_with_elements.at(i.into()) == Cell::Empty && player_placed == false {
                matrix_with_player.append(Cell::Player);
                player_placed = true;
            } else {
                matrix_with_player.append(*matrix_with_elements.at(i.into()));
            }
            i += 1;
        };
        matrix_with_player
    } else {
        matrix_with_elements
    }
}
