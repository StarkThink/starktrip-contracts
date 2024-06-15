#[derive(Model, Copy, Drop, Serde)]
struct GraphNode {
    #[key]
    id: u32,
    value: felt252,
    children: felt252,
    parents: felt252,
}

#[generate_trait]
impl GraphNodeImpl of GraphNodeTrait {
    #[inline(always)]
    fn new(id: u32, value: felt252, children: felt252, parents: felt252) -> GraphNode {
        GraphNode { id, value, children, parents }
    }
}
