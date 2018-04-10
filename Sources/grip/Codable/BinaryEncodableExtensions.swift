/// Implementations of BinaryCodable for built-in types.
import Foundation

extension Array: BinaryEncodeableArray {
    public func binaryEncode(to encoder: BinaryEncoder) throws {
        if Element.self is BinarySizedEncodable.Type {
            for element in self {
                let newEncoder = BinaryEncoder()
                try (element as! Encodable).encode(to: newEncoder)
                try encoder.encode(UInt32(newEncoder.data.count + 4))
                try newEncoder.data.encode(to: encoder)
            }

        } else {
            for element in self {
                try (element as! Encodable).encode(to: encoder)
            }
        }
    }
}

protocol BinaryEncodeableArray {
    func binaryEncode(to encoder: BinaryEncoder) throws
}

extension String: BinaryEncodable {
    public func binaryEncode(to encoder: BinaryEncoder) throws {
        try Array(self.utf8).binaryEncode(to: encoder)
    }
}

extension FixedWidthInteger where Self: BinaryEncodable {
    public func binaryEncode(to encoder: BinaryEncoder) {
        encoder.appendBytes(of: self.bigEndian)
    }
}

extension Int8: BinaryEncodable {}
extension UInt8: BinaryEncodable {}
extension Int16: BinaryEncodable {}
extension UInt16: BinaryEncodable {}
extension Int32: BinaryEncodable {}
extension UInt32: BinaryEncodable {}
extension Int64: BinaryEncodable {}
extension UInt64: BinaryEncodable {}
