use starknet::ContractAddress;

struct LeaderBoard {
    players: Players
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
    fn new(players: Players) -> LeaderBoard {
        LeaderBoard { players }
    }
}
