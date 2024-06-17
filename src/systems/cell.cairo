#[derive(Model, Copy, Drop, Serde)]
struct Cell {
    row: u8,
    col: u8,
    value: felt252,
    cellType: CellType
}

#[derive(Copy, Drop, PartialEq)]
enum CellType {
    Character,
    Empty,
    Planet,
    Start,
    Wall
}

#[generate_trait]
impl CellImpl of CellTrait {
    fn new(cellType: CellType) -> Cell {
        Cell {
            cellType : cellType
        }
    }

    fn isCharacter(self: @Cell) -> bool {
        *self.cellType == CellType::Character
    }

    fn isEmpty(self: @Cell) -> bool {
        *self.cellType == CellType::Empty
    }

    fn isPlanet(self: @Cell) -> bool {
        *self.cellType == CellType::Planet
    }

    fn isStart(self: @Cell) -> bool {
        *self.cellType == CellType::Start
    }

    fn isWall(self: @Cell) -> bool {
        *self.cellType == CellType::Wall
    }
}