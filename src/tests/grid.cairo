use systems::cell::Cell;
use systems::grid::Grid;


#[test]
#[available_gas(2000000)]
fn get_max_movements() {
    let mut grid = array![
        [CellTrait::new(0, 0, 'alien2', CellType::Character), 
         CellTrait::new(0, 1, '', CellType::Empty),
         CellTrait::new(0, 2, 'alien2', CellType::Planet)]
    ];

    let sut: Grid = GridTrait::new(grid);
    assert_eq!(sut.get_max_movements(), 3);
}
