use starktrip::utils::grid::{Cell, CellDisplay, CellIntoFelt252};

fn printMap(map: Array<Cell>, rows: u8, cols: u8) {
    let mut map_span = map.span();
    println!("map_span: {}", map_span.len());
    let mut x_index = 0;
    loop {
        if x_index == rows || map_span.is_empty(){
            break;
        }
        let mut y_index = 0;
        loop {
            if y_index == cols || map_span.is_empty() {
                break;
            }
            print!("{}", map_span.pop_front().unwrap());
            y_index += 1;
        };
        println!("");
        x_index += 1;
    };
}
