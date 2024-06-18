struct Board {
    #[key]
    game_id: u32,
    len_rows: u8,
    len_cols: u8,
    max_movements: u8,
    remaining_characters: u8
}

#[generate_trait]
impl BoardImpl of BoardTrait {
    #[inline(always)]
    fn new(
        game_id: u32, len_rows: u8, len_cols: u8, max_movements: u8, remaining_characters: u8
    ) -> Board {
        Board { game_id, len_rows, len_cols, max_movements, remaining_characters }
    }
}

