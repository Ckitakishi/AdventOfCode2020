import Foundation

public extension String {
    var componentsByLine: [String] {
        self.components(separatedBy: .newlines)
    }
    
    var intArray: [Int] {
        componentsByLine.compactMap { Int($0) }
    }
}
