import XCTest
@testable import grip

class StreamTypePacketTests: XCTestCase {

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    func test_that_we_can_build_a_stream_type_packet_from_bytes() {
        let stBytes: [UInt8] = [114, 1]
        var packet: StreamTypePacket?
        XCTAssertNoThrow(packet = try StreamTypePacket(bytes: stBytes))
        XCTAssertNotNil(packet)
        XCTAssertEqual(packet?.streamType, StreamType.video)
    }

}
