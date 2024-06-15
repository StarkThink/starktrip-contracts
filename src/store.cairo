use starknet::ContractAddress;

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

use starktrip::models::board::Board;
use starktrip::models::game::Game;
use starktrip::models::leader_board::{LeaderBoard, Players};
use starktrip::models::spaceship::Spaceship;

#[derive(Drop)]
struct Store {
    world: IWorldDispatcher
}

#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    fn get_game(ref self: Store, id: u32, spaceship_id: u32, board_id: u32) -> Game {
        get!(self.world, (id), (Game))
    }

    fn set_game(ref self: Store, game: Game) {
        set!(self.world, (game));
    }

    fn get_board(ref self: Store, id: u32) -> Board {
        get!(self.world, (id), (Board))
    }

    fn set_board(ref self: Store, board: Board) {
        set!(self.world, (board));
    }

    fn get_leader_board(ref self: Store, players: Players) -> LeaderBoard {
        get!(self.world, (players), (LeaderBoard))
    }

    fn set_leader_board(ref self: Store, leader_board: LeaderBoard) {
        set!(self.world, (leader_board));
    }

    fn get_spaceship(ref self: Store, id: u32) -> Spaceship {
        get!(self.world, (id), (Spaceship))
    }

    fn set_spaceship(ref self: Store, spaceship: Spaceship) {
        set!(self.world, (spaceship));
    }
}
