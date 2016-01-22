// Although I don't use any NS*, if you don't import NSString,
// String(format:, …) won't work like you expect!

import Foundation

func printSpiralWithRange(range: Range<Int>) {
    guard let first = range.first, let last = range.last else {
        preconditionFailure("range should contain at least one number.")
    }

    let cellWidth = String(last).characters.count + 1
    let blankCell = Array(count: cellWidth, repeatedValue: " ").joinWithSeparator("")

    let coilCount = coilCountForCellCount(range.count)
    let numberAtLocation = numberAtLocationWithFirstNumber(first)

    for y in -coilCount...coilCount {
        for x in -coilCount...coilCount {
            let number = numberAtLocation(x, y)
            let cell = number <= last ? String(format: "%*d", cellWidth, number) : blankCell
            print(cell, terminator: "")
        }
        print("")
    }
}

// How many times does the spiral loop around?
// Or, what is the radius, not counting the center?
// Maps 1 -> 0, 2...9 -> 1, 10...25 -> 2…
// See coilCountForCellCount.gcx.
private func coilCountForCellCount(cellCount: Int) -> Int {
    return Int(
        ceil(
            (
                sqrt(Double(cellCount))
                - 1.0
            )
            / 2.0
        )
    )
}

// Given the first number in the spiral, returns a function that determines the number at a given location.
private func numberAtLocationWithFirstNumber(first: Int) -> (Int, Int) -> Int {
    // This relies on long recursion, but is memoized for speed.
    var memo: [Location: Int] = [:]

    func numberAtLocation(locationX: Int, _ locationY: Int) -> Int {
        let location = Location(x: locationX, y: locationY)
        if let number = memo[location] {
            return number
        }

        let number: Int

        switch (locationX, locationY) {
        case (0, 0): // Center
            number = first
        case (0, -1): // Start of first coil
            number = numberAtLocation(0, 0) + 1
        case let (0, y) where y < 0: // Start of other coil
            let innerCoilLength = 8 * -(y + 1)
            number = numberAtLocation(0, y + 1) + innerCoilLength
        case let (x, y) where y < 0 && 0 < x && x <= -y: // Right of top edge of any coil
            number = numberAtLocation(x - 1, y) + 1
        case let (x, y) where 0 < x && y <= x: // Right edge of any coil
            number = numberAtLocation(x, y - 1) + 1
        case let (x, y) where 0 < y && -x <= y: // Bottom edge of any coil
            number = numberAtLocation(x + 1, y) + 1
        case let (x, y) where x < 0 && x <= y: // Left edge of any coil
            number = numberAtLocation(x, y + 1) + 1
        case let (x, y): // Left of top edge of any coil
            number = numberAtLocation(x - 1, y) + 1
        }

        memo[location] = number
        return number
    }

    return numberAtLocation
}

private struct Location: Hashable {
    let x: Int
    let y: Int
    var hashValue: Int {
        return x << 16 + y
    }
}

private func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
