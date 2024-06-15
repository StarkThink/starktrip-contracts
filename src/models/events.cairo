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
    round: u32,
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
