import Foundation

public struct NALU: CustomStringConvertible {
    
    public private(set) var data: [UInt8]
    
    var type: NALUType {
        return NALUType(rawValue: self.data[4] & 0x1f)!
    }
    
    var payloadSize: UInt32 {
        return fromByteArray(Array(self.data[0..<4]))
    }
    
    var totalSize: UInt32 {
        return UInt32(self.data.count)
    }
    
    
    init(data: [UInt8]) {
        self.data = data
    }
    
    public var description: String {
        return "NALU(type: \(self.type), size: \(self.totalSize))"
    }
    
}

public enum NALUType: UInt8, CustomStringConvertible {
    case Undefined           = 0
    case CodedSlice          = 1 // P/B Frame
    case DataPartitionA      = 2
    case DataPartitionB      = 3
    case DataPartitionC      = 4
    case IDR                 = 5 // I Frame
    case SEI                 = 6
    case SPS                 = 7 // Sequence Parameter Set
    case PPS                 = 8 // Picture Parameter Set
    case AccessUnitDelimiter = 9
    case EndOfSequence       = 10
    case EndOfStream         = 11
    case FilterData          = 12
    
    public var description : String {
        switch self {
        case .CodedSlice:           return "CodedSlice"
        case .DataPartitionA:       return "DataPartitionA"
        case .DataPartitionB:       return "DataPartitionB"
        case .DataPartitionC:       return "DataPartitionC"
        case .IDR:                  return "IDR"
        case .SEI:                  return "SEI"
        case .SPS:                  return "SPS"
        case .PPS:                  return "PPS"
        case .AccessUnitDelimiter:  return "AccessUnitDelimiter"
        case .EndOfSequence:        return "EndOfSequence"
        case .EndOfStream:          return "EndOfStream"
        case .FilterData:           return "FilterData"
        default:                    return "Undefined"
        }
    }
}

public struct NALUStreamIterator: Sequence, IteratorProtocol {
    
    let streamBytes: [UInt8]
    var currentIdx: Int = 0
    
    mutating public func next() -> NALU? {
        guard self.currentIdx < streamBytes.count else { return nil }
        
        let sizeBytes           = Array(self.streamBytes[currentIdx..<currentIdx+4])
        let naluSize: UInt32    = fromByteArray(sizeBytes)
        
        if naluSize <= self.streamBytes.count {
            let nextIdx = currentIdx + Int(naluSize) + 4
            
            let naluData = Array(streamBytes[currentIdx..<nextIdx])
            let nalu     = NALU(data: naluData)
            
            self.currentIdx += nextIdx
            return nalu
        }
        
        return nil
    }
    
}

