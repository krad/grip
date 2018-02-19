public enum PacketError: Error {
    case couldNotBuildParamSet
}

public enum PacketType: UInt8, BinaryEncodable {
    case videoParams     = 0x70
    case videoDimensions = 0x71
    case streamType      = 0x72
}
