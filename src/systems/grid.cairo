use alexandria_data_structures::queue::{Queue, QueueTrait};
use alexandria_data_structures::array_ext::ArrayTraitExt;
use core::poseidon::PoseidonTrait;
use core::poseidon::poseidon_hash_span;
use core::hash::{HashStateTrait, HashStateExTrait};


#[derive(Model, Copy, Drop, Serde)]
struct Grid {
    grid: Array<Array<Cell>>,
    max_movements: u8,
    start: Cell,
    characters: Felt252Dict<felt252>,
    planets: Felt252Dict<felt252>,
    edges: Felt252Dict<Nullable<Array<felt252>>>
}

const COORDINATES: [(i8, i8); 4] = [(-1, 0), (0, 1), (1, 0), (0, -1)];
const MAX_CARRY: u8 = 4;

#[generate_trait]
impl GridImpl of GridTrait {
    fn new(self: @Grid, grid: Array<Array<Cell>>) -> Grid {
        Grid {
            grid: grid,
        }
        
        *self.max_movements = *self.solve_grid();
    }

    fn get_rows(self: @Grid) -> u8 {
        *self.grid.len()
    }

    fn get_cols(self: @Grid) -> u8 {
        *self.grid.at(0).len()
    }

    fn get_max_movements(self: @Grid) -> u8 {
        self.max_movements
    }

    fn process_grid(self: @Grid) {
        let mut r = 0;
        let mut c = 0;
        let mut coord_index = 0;

        while r < *self.grid.len() {
            while c < *self.grid.at(0).len() {
                let mut current_cell = *self.grid.at(r*2).at(c*2);
                if current_cell.isStart() {
                    *self.start = current_cell;
                }
                else if current_cell.isCharacter() {
                    let hash_cell = PoseidonTrait::new()
                        .update(current_cell.row)
                        .update(current_cell.col)
                        .finalize();
                    *self.characters.insert(hash_cell, current_cell.value);
                }                
                else if current_cell.isPlanet() {
                    let hash_cell = PoseidonTrait::new()
                        .update(current_cell.row)
                        .update(current_cell.col)
                        .finalize();
                    *self.planets.insert(hash_cell, current_cell.value);
                }

                while coord_index < COORDINATES.len() {
                    let (dc, dc): (i8, i8) = COORDINATES.at(coord_index);
                    if 0 <= r*2 + dr < *self.grid.len() 
                    && 0 <= c*2+dc < *self.grid.at(0).len()
                    && *self.grid.at(r*2 + dr).at(c*2 + dc).isEmpty() {
                        let hash_cell = PoseidonTrait::new()
                            .update(current_cell.row)
                            .update(current_cell.col)
                            .finalize();
                        let cur_edge =  *self.grid.at(r*2 + dr).at(c*2 + dc);
                        let hash_edge = PoseidonTrait::new()
                            .update(cur_edge.row)
                            .update(cur_edge.col)
                            .finalize();
                        append_edge(*self.edges, hash_cell, hash_edge);
                    }
                    coord_index += 1;
                }
                c += 1;
            }
            r+=1;
        }
    }

    fn solve_grid(self: @Grid) {
        *self.process_grid();
        let mut queue = QueueTrait::<felt252>::new();
        let start_cell = PoseidonTrait::new().update_with(*self.start).finalize();
        let solver: (u8, felt252, Array<felt252>, Array<felt252>) = (0, start_cell, array![], array![]);
        queue.enqueue(solver);
        while queue.len() {
            let (movs, cell, carrying, done) = queue.dequeue();
            if *self.planets.contains(cell) && carrying.contains(*self.planets.get(cell)) {
                done.append(*self.planets.get(cell));
                carrying.insert(*self.planets.get(cell), 0);
            }
            if done.len() == *self.characters.len() {
                break movs;
            }

            let e = 0;
            let current_edges = get_edges(*self.edges, cell);
            while e < current_edges.len() {
                let edge = current_edges.at(e);
                if *self.characters.contains(edge) 
                && !done.contains(*self.characters.get(edge)) 
                && carrying.len() < MAX_CARRY {
                    carrying.append(*self.characters.get(edge))
                    queue.enqueue((movs + 1, edge, carrying, done));
                }
                queue.append((d+1, edge, carrying, done));
            }   
        }
    }
}

fn append_edge(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252, value: u8) {
    let (entry, arr) = dict.entry(index);
    let mut unboxed_val = arr.deref_or(array![]);
    unboxed_val.append(value);
    dict = entry.finalize(NullableTrait::new(unboxed_val));
}

fn get_edges(ref dict: Felt252Dict<Nullable<Array<u8>>>, index: felt252) -> Span<u8> {
    let (entry, _arr) = dict.entry(index);
    let mut arr = _arr.deref_or(array![]);
    let span = arr.span();
    dict = entry.finalize(NullableTrait::new(arr));
    span
}