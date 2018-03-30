public enum PacketError: Error {
    case couldNotBuildParamSet
}

public enum PacketType: UInt8, BinaryEncodable {
    case videoParams     = 0x70
    case videoDimensions = 0x71
    case streamType      = 0x72
    case video           = 0x75 // v
    case audio           = 0x61 // a
}

public protocol Packet {
    var type: PacketType { get }
}
