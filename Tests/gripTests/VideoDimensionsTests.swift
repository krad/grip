import XCTest
@testable import grip

class VideoDimensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    func test_that_we_can_create_a_video_dimension_struct_from_network_data() {
        let packet: [UInt8] = [113, 0, 0, 2, 128, 0, 0, 1, 224]
        let dimensions      = VideoDimensions(from: packet)
        XCTAssertEqual(640, dimensions.width)
        XCTAssertEqual(480, dimensions.height)
    }
    
    func test_that_we_can_encode_and_decode_video_dimension_packets() {
        
        let dimensions = VideoDimensions(width: 640, height: 480)
        let dimBytes   = try? BinaryEncoder.encode(dimensions)
        XCTAssertNotNil(dimBytes)
        
        let bytesWithoutSize = Array(dimBytes![4..<dimBytes!.count])
        let outPacket        = VideoDimensions(from: bytesWithoutSize)
        XCTAssertEqual(outPacket.type, .videoDimensions)
        XCTAssertEqual(outPacket.width, 640)
        XCTAssertEqual(outPacket.height, 480)
        
    }
    
}

