extension Sequence {
    public func reduceCount(_ value: (Element) -> Int) -> Int {
        reduce(0) { $0 + value($1) }
    }
}
