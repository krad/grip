public struct VideoSamplePacket: BinaryEncodable {
    var type: CompressedSampleType             = .video
    public var isSync: Bool                    = true
    public var dependsOnOther: Bool            = false
    public var earlierDisplayTimesAllows: Bool = false
    
    public var duration: Int64      = 0
    public var timescale: UInt32    = 0
    
    public var data: [UInt8]
    
    public init(duration: Int64, timescale: UInt32, data: [UInt8]) {
        self.duration   = duration
        self.timescale  = timescale
        self.data       = data
    }
}
