use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Game {
    #[key]
    id: u32,
    score: u32,
    round: u32,
    player_name: felt252,
    owner: ContractAddress,
    state: bool
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline(always)]
    fn new(
        id: u32, score: u32, round: u32, player_name: felt252, owner: ContractAddress, state: bool
    ) -> Game {
        Game { id, score: 0, round: 1, player_name, owner, state: true }
    }
}
