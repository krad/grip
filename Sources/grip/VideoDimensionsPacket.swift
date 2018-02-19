public struct VideoDimensionPacket: BinarySizedEncodable {
    var marker: PacketType = .videoDimensions
    public var width: UInt32
    public var height: UInt32
    
    public init(width: UInt32, height: UInt32) {
        self.width  = width
        self.height = height
    }
}

