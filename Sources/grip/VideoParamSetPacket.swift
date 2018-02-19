struct VideoParamSetPacket: BinarySizedEncodable {
    var markerA: PacketType = .videoParams
    var sps: [UInt8]
    
    var markerB: PacketType = .videoParams
    var pps: [UInt8]
    
    init(params: [[UInt8]]) throws {
        if let sps = params.first { self.sps = sps }
        else { throw PacketError.couldNotBuildParamSet }
        
        if let pps = params.last { self.pps = pps }
        else { throw PacketError.couldNotBuildParamSet }
    }
}

