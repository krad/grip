public struct StreamTypePacket: BinarySizedEncodable {
    public var type: PacketType = .streamType
    public var streamType: StreamType
    
    public init(streamType: StreamType) {
        self.streamType = streamType
    }
}


extension StreamTypePacket: Packet { }
