//
//  HTTPRangeField.swift
//
//
//  Created by Edon Valdman on 7/21/24.
//

import Foundation

/// The value of a `Range` HTTP header.
///
/// It notes the units that ``ranges`` is measured in, then lists range(s).
///
/// See [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range) for more detail.
public struct HTTPRangeField: Hashable, Sendable, RawRepresentable {
    /// The unit that ``ranges`` is measured in.
    public let unit: HTTPRange.Unit
    /// The field's range(s).
    public let ranges: [HTTPRange]
    
    public init(unit: HTTPRange.Unit, ranges: [HTTPRange]) {
        self.unit = unit
        self.ranges = ranges
    }
    
    /// The value rendered for insertion in a header field.
    public var rawValue: String {
        return "\(unit.rawValue)=\(ranges.map(\.rawValue).joined(separator: ", "))"
    }
    
    /// Initialize from the raw string of a header field.
    public init?(rawValue: String) {
        let split = rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(maxSplits: 2, whereSeparator: { $0 == "=" })
        
        // 0-50, 100-150
        let ranges: [HTTPRange] = split[1].components(separatedBy: ", ").compactMap { exp in
            return .init(rawValue: exp)
        }
        
        self = .init(unit: .init(rawValue: String(split[0])), ranges: ranges)
    }
}

extension HTTPRangeField: CustomStringConvertible {
    public var description: String { rawValue }
}
