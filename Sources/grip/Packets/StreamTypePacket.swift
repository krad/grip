public struct StreamTypePacket: BinarySizedEncodable {
    public var type: PacketType = .streamType
    public var streamType: StreamType
    
    public init(streamType: StreamType) {
        self.streamType = streamType
    }
    
    public init(bytes: [UInt8]) throws  {
        if let st = StreamType.parse(bytes) { self.streamType = st }
        else { throw PacketError.couldNotBuildPacket }
    }
}


extension StreamTypePacket: Packet { }
