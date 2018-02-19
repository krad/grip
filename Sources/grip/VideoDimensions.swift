public struct VideoDimensions {
    public var width: UInt32
    public var height: UInt32
    
    public init(from data: [UInt8]) {
        self.width  = UInt32(bytes: Array(data[1..<5]))!
        self.height = UInt32(bytes: Array(data[5..<data.count]))!
    }
    
    internal init(width: UInt32, height: UInt32) {
        self.width  = width
        self.height = height
    }
}

public func ==(lhs: VideoDimensions, rhs: VideoDimensions) -> Bool {
    if lhs.width == rhs.width {
        if lhs.height == rhs.height {
            return true
        }
    }
    return false
}

extension VideoDimensions: Equatable { }
