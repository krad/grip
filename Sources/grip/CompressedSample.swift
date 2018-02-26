import Foundation

public protocol CompressedSample {
    var type: CompressedSampleType { get }
    var data: [UInt8] { get }
    var size: UInt32 { get }
    var duration: Int64 { get }
    var durationInSeconds: TimeInterval { get }
    
    var decode: TimeInterval { get set }
    var timescale: UInt32 { get }
    var isSync: Bool { get }
}

extension CompressedSample {
    public var durationInSeconds: TimeInterval {
        return TimeInterval(self.duration) / TimeInterval(self.timescale)
    }
}
