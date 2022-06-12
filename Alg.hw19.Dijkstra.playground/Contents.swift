typealias Vertex = String
typealias Cost = Int
typealias Graph = [Vertex: [Vertex: Cost]]
typealias ParentsTable = [Vertex: (cost: Cost, parent: Vertex?)]

let infinity = Int.max

var graph = Graph()
graph["A"] = ["B": 2, "C": 3, "D": 6]
graph["B"] = ["A": 2, "C": 4, "E": 9]
graph["C"] = ["A": 3, "B": 4, "D": 1, "E": 7, "F": 6]
graph["D"] = ["A": 6, "C": 1, "F": 4]
graph["E"] = ["B": 9, "C": 7, "F": 1, "G": 5]
graph["F"] = ["C": 6, "D": 4, "E": 1, "G": 8]
graph["G"] = ["E": 5, "F": 8]

let startVertex = "A", finishVertex = "G"

var parentsTable = initParentsTable(for: graph, with: startVertex)
var checked = Set<Vertex>()

while let vertex = findLowestCostVertex(for: parentsTable, with: checked) {
    guard let neighbors = graph[vertex] else { continue }
    for (neighborsVertex, neighborsCost) in neighbors {
        let neighborsVertexCost = parentsTable[neighborsVertex]!.cost
        let newNeighborsVertexCost = parentsTable[vertex]!.cost + neighborsCost
        if newNeighborsVertexCost < neighborsVertexCost {
            parentsTable[neighborsVertex] = (cost: newNeighborsVertexCost, parent: vertex)
        }
        if neighborsVertex == finishVertex {
            break
        }
    }
    checked.insert(vertex)
}

let path = getPath(in: parentsTable, for: finishVertex)
print(path)

func initParentsTable(for graph: Graph, with startVertex: Vertex) -> ParentsTable {
    var parentsTable = ParentsTable()
    for vertex in graph.keys {
        parentsTable[vertex] = (cost: vertex == startVertex ? 0 : infinity, parent: nil)
    }
    return parentsTable
}

func getPath(in parentsTable: ParentsTable, for finishVertex: Vertex) -> [Vertex] {
    var path = [Vertex](), cost = 0
    var vertex = finishVertex
    while let data = parentsTable[vertex] {
        path.append(vertex)
        cost += data.cost
        guard let parent = data.parent else { break }
        vertex = parent
    }
    return Array(path.reversed())
}

func findLowestCostVertex(for parentsTable: ParentsTable, with checked: Set<Vertex>) -> Vertex? {
    var lowestCost = infinity, lowestCostVertex: Vertex?
    for (vertex, data) in parentsTable {
        guard !checked.contains(vertex) else { continue }
        if data.cost < lowestCost {
            lowestCost = data.cost
            lowestCostVertex = vertex
        }
    }
    return lowestCostVertex
}
