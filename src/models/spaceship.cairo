#[derive(Model, Copy, Drop, Serde)]
struct Spaceship {
    #[key]
    game_id: u32,
    pos_x: u8,
    pos_y: u8,
    remaining_gas: u8,
    len_characters_inside: u8
}

#[generate_trait]
impl SpaceshipImpl of SpaceshipTrait {
    #[inline(always)]
    fn new(
        game_id: u32, pos_x: u8, pos_y: u8, remaining_gas: u8, len_characters_inside: u8
    ) -> Spaceship {
        Spaceship { game_id, pos_x, pos_y, remaining_gas, len_characters_inside }
    }
}
