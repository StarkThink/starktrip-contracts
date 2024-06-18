#[derive(Model, Copy, Drop, Serde)]
struct CharactersInside {
    #[key]
    id: u32,
    #[key]
    game_id: u32,
    value: felt252
}

#[generate_trait]
impl CharactersInsideImpl of CharactersInsideTrait {
    #[inline(always)]
    fn new(id: u32, game_id: u32, value: felt252) -> CharactersInside {
        CharactersInside { id, game_id, value }
    }
}
