import Foundation

extension String {
    public var componentsByLine: [String] {
        self.components(separatedBy: .newlines)
    }
    
    public var componentsByGroup: [String] {
        self.components(separatedBy: "\n\n")
    }
    
    public var intArray: [Int] {
        componentsByLine.compactMap { Int($0) }
    }
}
