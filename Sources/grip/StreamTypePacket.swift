struct StreamTypePacket: BinarySizedEncodable {
    var marker: PacketType = .streamType
    var streamType: StreamType
    
    init(streamType: StreamType) {
        self.streamType = streamType
    }
}


