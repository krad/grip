public struct VideoDimensions {
    var width: UInt32
    var height: UInt32
    
    public init(from data: [UInt8]) {
        self.width  = UInt32(bytes: Array(data[1..<5]))!
        self.height = UInt32(bytes: Array(data[5..<data.count]))!
    }
    
    internal init(width: UInt32, height: UInt32) {
        self.width  = width
        self.height = height
    }
}

