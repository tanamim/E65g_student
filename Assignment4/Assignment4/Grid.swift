//
//  Grid.swift
//
import Foundation

public typealias GridPosition = (row: Int, col: Int)
public typealias GridSize = (rows: Int, cols: Int)

fileprivate func norm(_ val: Int, to size: Int) -> Int { return ((val % size) + size) % size }

public enum CellState : String {
    // Assignment3 Part1
    case alive = "alive"
    case empty = "empty"
    case born  = "born"
    case died  = "died"
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
    
    public func description() -> String {
        switch self {  // spec asked to use switch statement
        default: return self.rawValue
        }
    }
    
    public func allValues() -> [CellState] {
        return [.alive, .empty, .born, .died]
    }
    
    public func toggle(value: CellState) -> CellState {
        switch self {
        case .empty, .died: return .alive
        case .alive, .born: return .empty
        }
    }
}


public protocol GridProtocol {
    init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState)
    var description: String { get }
    var size: GridSize { get }
    subscript (row: Int, col: Int) -> CellState { get set }
    func next() -> Self 
}

public let lazyPositions = { (size: GridSize) in
    return (0 ..< size.rows)
        .lazy
        .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
        .flatMap { $0 }
        .map { GridPosition($0) }
}


let offsets: [GridPosition] = [
    (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
    (row:  0, col:  -1),                     (row:  0, col:  1),
    (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
]

extension GridProtocol {
    public var description: String {
        return lazyPositions(self.size)
            .map { (self[$0.row, $0.col].isAlive ? "*" : " ") + ($0.col == self.size.cols - 1 ? "\n" : "") }
            .joined()
    }
    
    private func neighborStates(of pos: GridPosition) -> [CellState] {
        return offsets.map { self[pos.row + $0.row, pos.col + $0.col] }
    }
    
    private func nextState(of pos: GridPosition) -> CellState {
        let iAmAlive = self[pos.row, pos.col].isAlive
        let numLivingNeighbors = neighborStates(of: pos).filter({ $0.isAlive }).count
        switch numLivingNeighbors {
        case 2 where iAmAlive,
             3: return iAmAlive ? .alive : .born
        default: return iAmAlive ? .died  : .empty
        }
    }
    
    public func next() -> Self {
        var nextGrid = Self(size.rows, size.cols) { _, _ in .empty }
        lazyPositions(self.size).forEach { nextGrid[$0.row, $0.col] = self.nextState(of: $0) }
        return nextGrid
    }
}

public struct Grid: GridProtocol {
    private var _cells: [[CellState]]
    public let size: GridSize

    public subscript (row: Int, col: Int) -> CellState {
        get { return _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }
    
    public init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState = { _, _ in .empty }) {
        _cells = [[CellState]](repeatElement( [CellState](repeatElement(.empty, count: rows)), count: cols))
        size = GridSize(rows, cols)
        lazyPositions(self.size).forEach { self[$0.row, $0.col] = cellInitializer($0) }
    }
}

extension Grid: Sequence {
    fileprivate var living: [GridPosition] {
        return lazyPositions(self.size).filter { return  self[$0.row, $0.col].isAlive   }
    }
    
    public struct GridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [GridPosition]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [GridPosition], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: GridProtocol
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> GridProtocol? {
            if history.hasCycle { return nil }
            let newGrid:Grid = grid.next() as! Grid
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> GridIterator { return GridIterator(grid: self) }
}

public extension Grid {
    public static func gliderInitializer(pos: GridPosition) -> CellState {
        switch pos {
        case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
        default: return .empty
        }
    }
}


// Engine Implementation (Assignment4 Part3)
protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}


protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(_ rows: Int, _ cols: Int)
    func step() -> GridProtocol
}


// for Statistics
struct GridStat {
    var alive: Int
    var born: Int
    var died: Int
    var empty: Int
}


//@available(iOS 10.0, *)
class StandardEngine: EngineProtocol {
    var delegate: EngineDelegate?
    var rows: Int
    var cols: Int

    // this value will be changed by StatUpdate notification
    var gridStat: GridStat
    
    var grid: GridProtocol
    var refreshRate: Double
    var isRefresh: Bool  // Dev
    var refreshTimer: Timer?
    var timerInterval: TimeInterval = 0.0 {
        didSet {
            if timerInterval > 0.0 {
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: timerInterval,
                    repeats: true
                ) { (t: Timer) in
                    self.grid = self.step()
                }
            }
            else {
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
        }
    }
    
    static let engine = StandardEngine(10, 10)  // Shared instance
    
    internal required init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols
        self.gridStat = GridStat(alive: 0, born: 0, died: 0, empty: 100)
        self.grid = Grid(rows, cols)
        self.refreshRate = 3.0
        self.isRefresh = false
    }
    
    func step() -> GridProtocol {
        grid = grid.next()
        delegate?.engineDidUpdate(withGrid: grid)
        return grid
    }

    // DEBUG
    func refreshSimulation() -> Void {
        print("refreshSimulation! rows: \(rows) cols: \(cols)")
        grid = Grid(rows, cols)
        delegate?.engineDidUpdate(withGrid: grid)
    }
    
    func sayHello() -> Void {
        print("[Hello!! size is \(self.rows)]")
    }
    
    func sayHello2() -> Void {
        print("[Hello2!! size is \(self.rows)]")
    }
    
    // Statistics updater.
    func statGenerate() -> Void {
        var alive = 0
        var born = 0
        var died = 0
        var empty = 0
        (0 ..< self.rows).forEach { i in
            (0 ..< self.cols).forEach { j in
                switch grid[(i,j)] {
                case .alive: alive += 1
                case .born:  born += 1
                case .died:  died += 1
                case .empty: empty += 1
                }
            }
        }
        print(alive, born, died, empty)
        self.gridStat.alive = alive
        self.gridStat.born = born
        self.gridStat.died = died
        self.gridStat.empty = empty
        print("statGenerate", alive, born, died, empty)
    }
    
    func statPublish() -> Void {
        print("statPublish!")

        self.statGenerate() // DEBUG
        
        // notification pualisher
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "StatUpdate")
        let n = Notification(name: name, object: nil, userInfo: ["StandardEngine": self])
        nc.post(n)
    }
}











