public extension Array where Element: Equatable {
    func prependingIfNotContains(_ value: Element?) -> Array {
        guard let value = value else { return self }
        if contains(where: { $0 == value }) {
            return self
        } else {
            return prepending(value)
        }
    }

    func appending(_ value: Element) -> Array {
        var result = self
        result.append(value)
        return result
    }
}

public extension Array {
    func prepending(_ value: Element) -> Array {
        var result = self
        result.insert(value, at: 0)
        return result
    }
}
