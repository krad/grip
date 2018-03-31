import Foundation

public struct VideoSample: BinaryEncodable {
    
    public var type: PacketType                = .video
    public var isSync: Bool                    = true
    public var dependsOnOthers: Bool           = false
    public var earlierDisplayTimesAllows: Bool = false
    
    public var duration: Int64      = 0
    public var timescale: UInt32    = 0
    public var decode: Double       = 0

    public var data: [UInt8]
    
    public var nalus: [NALU] {
        var result: [NALU] = []
        let iterator = NALUStreamIterator(streamBytes: self.data, currentIdx: 0)
        for nalu in iterator {
            result.append(nalu)
        }
        return result
    }
    
    public var size: UInt32 { return self.nalus.reduce(0, {last, nalu in last + nalu.totalSize})}
    
    public var durationInSeconds: TimeInterval {
        return TimeInterval(duration) / TimeInterval(timescale)
    }
    
    public init(duration: Int64, timescale: UInt32, data: [UInt8]) {
        self.duration   = duration
        self.timescale  = timescale
        self.data       = data
    }
        
    public init(bytes: [UInt8]) {
        self.type                       = .video
        self.isSync                     = bytes[1].toBool()
        self.dependsOnOthers            = bytes[2].toBool()
        self.earlierDisplayTimesAllows  = bytes[3].toBool()
        self.duration                   = fromByteArray(Array(bytes[4..<12]))
        self.timescale                  = fromByteArray(Array(bytes[12..<16]))
        self.decode                     = fromByteArray(Array(bytes[16..<MemoryLayout<Double>.size+16]))
        self.data                       = Array(bytes[MemoryLayout<Double>.size+16..<bytes.count])
    }
}

extension VideoSample: Packet { }
extension VideoSample: CompressedSample { }
