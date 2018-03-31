import Foundation

public struct AudioSample: BinaryEncodable {
    
    public var type: PacketType     = .audio
    public var isSync: Bool         = false
    public let sampleSize: UInt16
    public let channels: UInt32
    public let sampleRate: Double
    
    public var duration: Int64     = 0
    public var timescale: UInt32   = 0
    public var decode: Double      = 0
    
    public var data: [UInt8]
    
    public var size: UInt32 {
        return UInt32(self.data.count)
    }
    
    public var durationInSeconds: TimeInterval {
        return TimeInterval(duration) / TimeInterval(timescale)
    }
    
    public init(duration: Int64, timescale: UInt32, data: [UInt8]) {
        self.duration   = duration
        self.timescale  = timescale
        self.sampleRate = Double(timescale)
        self.sampleSize = 16
        self.channels   = 2
        self.data       = data
    }
    
    public init(bytes: [UInt8]) {
        self.type      = .audio
        self.isSync    = bytes[1].toBool()

        let sampleSizeEnd   = MemoryLayout<UInt16>.size+2
        let channelEnd      = sampleSizeEnd+MemoryLayout<UInt32>.size
        let sampleRateEnd   = channelEnd+MemoryLayout<Double>.size
        let durationEnd     = sampleRateEnd+MemoryLayout<Int64>.size
        let timescaleEnd    = durationEnd+MemoryLayout<UInt32>.size
        let decodeEnd       = timescaleEnd+MemoryLayout<Double>.size
        
        let sampleSizeRange = 2..<sampleSizeEnd
        let channelRange    = sampleSizeEnd..<channelEnd
        let sampleRateRange = channelEnd..<sampleRateEnd
        let durationRange   = sampleRateEnd..<durationEnd
        let timescaleRange  = durationEnd..<timescaleEnd
        let decodeRange     = timescaleEnd..<decodeEnd
        
        self.sampleSize = fromByteArray(Array(bytes[sampleSizeRange]))
        self.channels   = fromByteArray(Array(bytes[channelRange]))
        self.sampleRate = fromByteArray(Array(bytes[sampleRateRange]))
        self.duration   = fromByteArray(Array(bytes[durationRange]))
        self.timescale  = fromByteArray(Array(bytes[timescaleRange]))
        self.decode     = fromByteArray(Array(bytes[decodeRange]))
        
        self.data       = Array(bytes[decodeEnd..<bytes.count])
        
    }
}

extension AudioSample: Packet { }
extension AudioSample: CompressedSample { }
