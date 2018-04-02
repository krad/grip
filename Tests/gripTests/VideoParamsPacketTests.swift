import XCTest
@testable import grip

class VideoParamsPacketTests: XCTestCase {
    
    func test_that_we_can_parse_video_params_packet_from_network_bytes() {
        
        let bytes: [UInt8] = [0x70, 0x00, 0x00, 0x00, 0x00, 0x70, 0x11, 0x11, 0x11, 0x11]
        var packet: VideoParamSetPacket?
        XCTAssertNoThrow(packet = try VideoParamSetPacket(bytes: bytes))
        XCTAssertNotNil(packet)
        XCTAssertEqual(4, packet?.sps.count)
        XCTAssertEqual(4, packet?.pps.count)
        
        XCTAssertEqual([0x00, 0x00, 0x00, 0x00], packet!.sps)
        XCTAssertEqual([0x11, 0x11, 0x11, 0x11], packet!.pps)
        
    }

}
