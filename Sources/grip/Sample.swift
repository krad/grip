import Foundation

public protocol Sample {
    var type: SampleType { get }
    var data: [UInt8] { get }
    var size: UInt32 { get }
    var duration: Int64 { get }
    var durationInSeconds: TimeInterval { get }
    
    var decode: TimeInterval { get set }
    var timescale: UInt32 { get }
    var isSync: Bool { get }
}

extension Sample {
    public var durationInSeconds: TimeInterval {
        return TimeInterval(self.duration) / TimeInterval(self.timescale)
    }
}
