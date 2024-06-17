#[derive(Model, Copy, Drop, Serde)]
struct Board {
    #[key]
    id: u32,
    #[key]
    game_id: u32,
    len_rows: u8,
    len_cols: u8,
    max_movements: u8,
    animals_to_deliver: u8
}

#[generate_trait]
impl BoardImpl of BoardTrait {
    #[inline(always)]
    fn new(id: u32, game_id: u32, len_rows: u8, len_cols: u8, max_movements: u8, animals_to_deliver: u8) -> Board {
        Board { id, game_id, len_rows, len_cols, max_movements, animals_to_deliver }
    }
}
