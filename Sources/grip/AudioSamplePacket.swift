struct AudioSamplePacket: BinaryEncodable {
    var type: SampleType    = .audio
    var duration: Int64     = 0
    var timescale: UInt32   = 0
    var data: [UInt8]
    
    init(duration: Int64, timescale: UInt32, data: [UInt8]) {
        self.duration   = duration
        self.timescale  = timescale
        self.data       = data
    }
}
