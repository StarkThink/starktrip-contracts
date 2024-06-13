use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct Game {
    #[key]
    id: u32,
    #[key]
    spaceship_id: u32,
    #[key]
    board_id: u32,
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
        id: u32,
        spaceship_id: u32,
        board_id: u32,
        score: u32,
        round: u32,
        player_name: felt252,
        owner: ContractAddress,
        state: bool
    ) -> Game {
        Game { id, spaceship_id, board_id, score: 0, round: 1, player_name, owner, state: true }
    }
}
