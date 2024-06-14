use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct LeaderBoard {
    #[key]
    players: Players,
    score: u32
}

#[derive(Model, Copy, Drop, Serde)]
struct Players {
    #[key]
    player: ContractAddress,
    score: u32
}

#[generate_trait]
impl LeaderBoardImpl of LeaderBoardTrait {
    #[inline(always)]
    fn new(players: Players, score: u32) -> LeaderBoard {
        LeaderBoard { players, score }
    }
}
