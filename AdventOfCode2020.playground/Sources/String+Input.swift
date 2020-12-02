public extension String {
    var intArray: [Int] {
        self.split(separator: "\n").compactMap { Int($0) }
    }
}
