import Foundation

public struct AudioSample: CompressedSample {
    
    public let type: CompressedSampleType
    public let data: [UInt8]
    
    public var size: UInt32 {
        return UInt32(self.data.count)
    }
    
    public var duration: Int64                  = 0
    public var durationSeconds: TimeInterval    = 0
    public var decode: TimeInterval             = 0
    public var timescale: UInt32                = 0
    
    public var isSync: Bool = false
    
    public let sampleSize: UInt16
    public let channels: UInt32
    public let sampleRate: Double
    
    public init(bytes: [UInt8]) {
        self.type            = .audio
        self.duration        = Int64(bytes: Array(bytes[1..<9]))!
        self.timescale       = UInt32(bytes: Array(bytes[9..<13]))!
        self.durationSeconds = TimeInterval(duration) / TimeInterval(timescale)
        
        self.sampleSize = 16
        self.channels   = 2
        self.sampleRate = Double(self.timescale)
        
        let audioBytes = Array(bytes[13..<bytes.count])
        self.data      = audioBytes
    }
    
}

