use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct CreateGame {
    #[key]
    game_id: u32,
    player_address: ContractAddress
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct GameWin {
    #[key]
    game_id: u32,
    #[key]
    player_address: ContractAddress,
    round: u8,
    score: u32
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct GameOver {
    #[key]
    game_id: u32,
    player_address: ContractAddress
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct GameEvent {
    #[key]
    id: u32,
    score: u32,
    round: u8
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct Move {
    #[key]
    game_id: u32,
    pos_x: u8,
    pos_y: u8,
    remaining_gas: u8
}
