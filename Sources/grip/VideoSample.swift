import Foundation

public struct VideoSample: Sample {
    
    public var type: SampleType
    public var nalus: [NALU] = []
    
    public var data: [UInt8] {
        var results: [UInt8] = []
        for nalu in nalus {
            results.append(contentsOf: nalu.data)
        }
        return results
    }
    
    public var duration: Int64                  = 0
    public var durationSeconds: TimeInterval    = 0
    public var decode: Double                   = 0
    public var timescale: UInt32                = 0
    
    public var size: UInt32 { return self.nalus.reduce(0, { last, nalu in last + nalu.totalSize }) }
    
    public var dependsOnOthers: Bool            = false
    public var isSync: Bool                     = false
    public var earlierDisplayTimesAllowed: Bool = false
    
    public init(bytes: [UInt8]) {
        self.type                       = .video
        self.isSync                     = bytes[1].toBool()
        self.dependsOnOthers            = bytes[2].toBool()
        self.earlierDisplayTimesAllowed = bytes[3].toBool()
        self.duration                   = Int64(bytes: Array(bytes[4..<12]))!
        self.timescale                  = UInt32(bytes: Array(bytes[12..<16]))!
        self.durationSeconds            = TimeInterval(duration) / TimeInterval(timescale)
        
        let videoBytes = Array(bytes[16..<bytes.count])
        for nalu in NALUStreamIterator(streamBytes: videoBytes, currentIdx: 0) {
            self.nalus.append(nalu)
        }
    }
    
}
