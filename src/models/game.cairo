use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Game {
    #[key]
    id: u32,
    owner: ContractAddress,
    player_name: felt252,
    score: u32,
    round: u8,
    active: bool
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline(always)]
    fn new(
        id: u32, owner: ContractAddress, player_name: felt252, score: u32, round: u8, active: bool
    ) -> Game {
        Game { id, owner, player_name, score, round, active }
    }
}
