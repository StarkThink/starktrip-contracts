#[derive(Model, Copy, Drop, Serde)]
struct GraphNode {
    #[key]
    id: u32,
    value: felt252,
    children: Vec<u32>,
    parents: Vec<u32>,
}

#[generate_trait]
impl GraphNodeImpl of GraphNodeTrait {
    #[inline(always)]
    fn new(id: u32, value: felt252, children: Vec<u32>, parents: Vec<u32>) -> GraphNode {
        GraphNode { id, game_id, rows, max_movements, animals_to_deliver }
    }
}
