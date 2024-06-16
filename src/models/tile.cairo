#[derive(Model, Copy, Drop, Serde)]
struct Tile {
    #[key]
    row_id: u32,
    #[key]
    col_id: u32,
    #[key]
    game_id: u32,
    value: felt252
}

#[generate_trait]
impl TileImpl of TileTrait {
    #[inline(always)]
    fn new(row_id: u32, col_id: u32, game_id: u32, value: felt252) -> Tile {
        Tile { row_id, col_id, game_id, value }
    }
}
