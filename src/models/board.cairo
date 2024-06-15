#[derive(Model, Copy, Drop, Serde)]
struct Board {
    #[key]
    id: u32,
    root: felt252,
    children: felt252,
    game_id: u32,
    max_movements: u8,
    animamals_to_deliver: u8,
}

#[generate_trait]
impl BoardImpl of BoardTrait {
    #[inline(always)]
    fn new(id: u32, game_id: u32, rows: u8, max_movements: u8) -> Board {
        Board { id, game_id, rows, max_movements }
    }
}
