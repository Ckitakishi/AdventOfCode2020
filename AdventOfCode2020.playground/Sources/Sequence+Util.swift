extension Sequence {
    public func reduceCount(_ value: (Element) -> Int) -> Int {
        reduce(0) { $0 + value($1) }
    }
    
    public func reduceMultiply(_ value: (Element) -> Int) -> Int {
        reduce(1) { $0 * value($1) }
    }
}
