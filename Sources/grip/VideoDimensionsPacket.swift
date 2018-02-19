struct VideoDimensionPacket: BinarySizedEncodable {
    var marker: PacketType = .videoDimensions
    var width: UInt32
    var height: UInt32
    
    init(width: UInt32, height: UInt32) {
        self.width  = width
        self.height = height
    }
}

