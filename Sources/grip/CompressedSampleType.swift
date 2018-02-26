import Foundation

public enum CompressedSampleType: UInt8, BinaryEncodable {
    case video    = 0x75 // v
    case audio    = 0x61 // a
}

