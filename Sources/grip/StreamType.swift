import Foundation

public struct StreamType: OptionSet {
    public var rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static func parse(_ bytes: [UInt8]) -> StreamType? {
        guard bytes.count == 2 else { return nil }
        
        if let valueByte = bytes.last {
            guard valueByte >= 0 && valueByte <= 3 else { return nil }
            let streamType = StreamType(rawValue: valueByte)
            return streamType
        }
        return nil
    }
    
    public static let video = StreamType(rawValue: 1 << 0)
    public static let audio = StreamType(rawValue: 1 << 1)
    
    func supported(_ sample: Sample) -> Bool {
        if self == [.video, .audio] { return true }
        if self == [.video] && sample.type == .video { return true }
        if self == [.audio] && sample.type == .audio { return true }
        return false
    }
}

extension StreamType: BinaryEncodable { }
