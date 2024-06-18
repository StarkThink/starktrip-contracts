#[derive(Model, Copy, Drop, Serde)]
struct LeaderBoardPlayers {
    #[key]
    id: u32,
    player_name: felt252,
    score: u32
}

#[generate_trait]
impl LeaderBoardPlayersImpl of LeaderBoardPlayersTrait {
    #[inline(always)]
    fn new(id: u32, player_name: felt252, score: u32) -> LeaderBoardPlayers {
        LeaderBoardPlayers { id, player_name, score }
    }
}
