public struct VideoDimensions: BinarySizedEncodable {
    
    public var type: PacketType = .videoDimensions
    public var width: UInt32
    public var height: UInt32
    
    public init(width: UInt32, height: UInt32) {
        self.width  = width
        self.height = height
    }
    
    public init(from data: [UInt8]) {
        self.type   = PacketType(rawValue: data[0])!
        self.width  = fromByteArray(Array(data[1...4]))
        self.height = fromByteArray(Array(data[5..<data.count]))
    }
}

extension VideoDimensions: Packet { }

public func ==(lhs: VideoDimensions, rhs: VideoDimensions) -> Bool {
    if lhs.width == rhs.width {
        if lhs.height == rhs.height {
            return true
        }
    }
    return false
}

extension VideoDimensions: Equatable { }
