public struct StreamTypePacket: BinarySizedEncodable {
    var marker: PacketType = .streamType
    public var streamType: StreamType
    
    public init(streamType: StreamType) {
        self.streamType = streamType
    }
}


