import XCTest
@testable import grip

class NALUIteratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }

    func test_that_we_can_iterator_over_nalus() {
        
        var iterator = NALUStreamIterator(streamBytes: videoPayload, currentIdx: 0)
        let naluA = iterator.next()
        XCTAssertNotNil(naluA)
        XCTAssertEqual(naluA?.type, .SEI)
        
        let naluB = iterator.next()
        XCTAssertNotNil(naluB)
        XCTAssertEqual(naluB?.type, .IDR)
        
    }


}
