#[derive(Model, Copy, Drop, Serde)]
struct LeaderBoard {
    #[key]
    id: u32,
    len_players: u32
}

#[generate_trait]
impl LeaderBoardImpl of LeaderBoardTrait {
    #[inline(always)]
    fn new(id: u32, len_players: u32) -> LeaderBoard {
        LeaderBoard { id, len_players }
    }
}
