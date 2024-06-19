use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Game {
    #[key]
    id: u32,
    owner: ContractAddress,
    player_name: felt252,
    score: u8,
    round: u8
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline(always)]
    fn new(
        id: u32, owner: ContractAddress, player_name: felt252, score: u8, round: u8
    ) -> Game {
        Game { id, owner, player_name, score, round }
    }
}
