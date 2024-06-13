#[derive(Model, Copy, Drop, Serde)]
struct Spaceship {
    #[key]
    id: u32,
    #[key]
    game_id: u32,
    pos_x: u32,
    pos_y: u32
}

#[generate_trait]
impl SpaceshipImpl of SpaceshipTrait {
    #[inline(always)]
    fn new(id: u32, game_id: u32, pos_x: u32, pos_y: u32) -> Spaceship {
        Spaceship { id, game_id, pos_x: 0, pos_y: 0 }
    }
}
