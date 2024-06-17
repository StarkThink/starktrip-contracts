#[derive(Model, Copy, Drop, Serde)]
struct Tile {
    #[key]
    game_id: u32,
    #[key]
    row_id: u32,
    #[key]
    column_id: u32,
    value: felt252
}

#[generate_trait]
impl TileImpl of TileTrait {
    #[inline(always)]
    fn new(game_id: u32, row_id: u32, column_id: u32, value: felt252)-> Tile {
        Tile { game_id, row_id, column_id, value}
    }

    fn get_value() -> felt252 {
        self.value
    }

    fn get_row() -> u32 {
        self.row_id
    }

    fn get_column() -> u32 {
        self.column_id
    }
}