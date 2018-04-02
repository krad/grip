import Foundation

public func toByteArray<T: FixedWidthInteger>(_ value: T) -> [UInt8] {
    var bigEndian = value.bigEndian
    let count = MemoryLayout<T>.size
    let bytePtr = withUnsafePointer(to: &bigEndian) {
        $0.withMemoryRebound(to: UInt8.self, capacity: count) {
            UnsafeBufferPointer(start: $0, count: count)
        }
    }
    return Array(bytePtr)
}

public func fromByteArray<T>(_ value: [UInt8]) -> T {
    return value.reversed().withUnsafeBytes {
        $0.baseAddress!.load(as: T.self)
    }
}

public extension Data {
    
    public var bytes: [UInt8] {
        var bytes = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &bytes, count: self.count)
        return bytes
    }
    
    public func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UInt8 {
    public func toBool() -> Bool {
        switch self {
        case 0x01:
            return true
        case 0x00:
            return false
        default:
            return false
        }
    }
}

