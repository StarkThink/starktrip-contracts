#[derive(Model, Copy, Drop, Serde)]
struct Spaceship {
    #[key]
    id: u32,
    game_id: u32,
    node_id: u32,
    movements: u8,
    delivered_animals: u8
}

#[generate_trait]
impl SpaceshipImpl of SpaceshipTrait {
    #[inline(always)]
    fn new(
        id: u32, game_id: u32, node_id: u32, movements: u8, delivered_animals: u8
    ) -> Spaceship {
        Spaceship { id, game_id, node_id, movements, delivered_animals }
    }
}
