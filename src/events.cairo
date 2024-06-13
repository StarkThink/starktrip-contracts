use starknet::ContractAddress;

#[derive(Drop, starknet::Event)]
struct CreateGame {
    #[key]
    game_id: u32,
    #[key]
    player_address: ContractAddress
}

#[derive(Drop, starknet::Event)]
struct GameWin {
    #[key]
    game_id: u32,
    #[key]
    player_address: ContractAddress,
    round: u32,
    score: u32
}

#[derive(Drop, starknet::Event)]
struct GameOver {
    #[key]
    game_id: u32,
    #[key]
    player_address: ContractAddress
}

#[derive(Drop, starknet::Event)]
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
