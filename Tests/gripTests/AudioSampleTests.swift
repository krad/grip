import XCTest
@testable import grip

class AudioSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    func test_that_we_can_create_an_audio_sample_from_bytes() {
        let sample = AudioSample(duration: 1024, timescale: 44100, data: audioPayload)
        XCTAssertEqual(sample.type, .audio)
        XCTAssertEqual(sample.timescale, 44100)
        XCTAssertEqual(sample.duration, 1024)
        XCTAssertEqual(Float(sample.durationInSeconds), 0.0232199546485261)
    }
    
    func test_that_we_can_encode_and_decode_audio_samples() {
        
        let sample = AudioSample(duration: 512, timescale: 48000, data: [0, 0, 0, 0, 0])
        do {
            let sampleBytes = try BinaryEncoder.encode(sample)
            XCTAssertNotNil(sampleBytes)
            
            let bytesWithoutSize = Array(sampleBytes[4..<sampleBytes.count])
            XCTAssertNotNil(bytesWithoutSize)
            
            let outSample = AudioSample(bytes: bytesWithoutSize)
            XCTAssertNotNil(outSample)
            XCTAssertEqual(outSample.isSync, false)
            XCTAssertEqual(outSample.sampleSize, 16)
            XCTAssertEqual(outSample.channels, 2)
            XCTAssertEqual(outSample.sampleRate, 48000.0)
            XCTAssertEqual(outSample.duration, 512)
            XCTAssertEqual(outSample.timescale, 48000)
            XCTAssertEqual(outSample.data, [0, 0, 0, 0, 0])
        } catch {
            XCTFail("\(error)")
        }
        
    }
    
}

let audioPayload: [UInt8] = [97, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 172, 68, 33, 78, 249, 67, 89, 167, 21, 16, 144, 85, 174, 209, 21, 127, 1, 123, 60, 238, 105, 51, 61, 237, 62, 61, 117, 190, 135, 219, 242, 251, 221, 113, 119, 232, 219, 178, 7, 90, 196, 224, 1, 55, 115, 134, 164, 37, 251, 255, 117, 100, 243, 26, 215, 173, 138, 93, 103, 139, 141, 235, 121, 237, 151, 94, 231, 250, 174, 107, 136, 149, 203, 51, 179, 239, 33, 61, 195, 228, 180, 147, 15, 138, 108, 232, 4, 175, 93, 145, 184, 236, 54, 167, 139, 103, 145, 157, 98, 39, 58, 102, 168, 152, 248, 39, 79, 220, 79, 239, 147, 11, 220, 58, 202, 112, 107, 238, 72, 94, 219, 78, 73, 151, 83, 68, 164, 165, 76, 26, 85, 71, 140, 220, 112, 144, 213, 88, 101, 180, 69, 40, 78, 116, 206, 138, 113, 231, 205, 91, 154, 37, 36, 200, 132, 207, 84, 209, 1, 5, 34, 88, 31, 194, 140, 91, 213, 69, 56, 185, 33, 68, 108, 33, 16, 5, 144, 163, 2, 149, 170, 196, 171, 200, 140, 34, 140, 18, 38, 95, 161, 81, 71, 95, 182, 67, 216, 13, 182, 79, 234, 65, 21, 40, 246, 214, 106, 28, 169, 252, 207, 245, 240, 154, 239, 19, 190, 32, 9, 149, 151, 181, 19, 95, 244, 5, 235, 196, 91, 217, 112, 0, 32, 82, 121, 221, 115, 113, 219, 185, 77, 123, 64, 189, 113, 87, 26, 41, 37, 210, 171, 173, 137, 234, 245, 23, 216, 224, 31, 210, 202, 232, 252, 86, 76, 6, 76, 22, 160, 201, 28, 96, 68, 104, 251, 95, 165, 116, 135, 213, 39, 210, 203, 107, 248, 66, 3, 78, 14, 174, 235, 253, 69, 174, 183, 139, 152, 68, 168, 249, 123, 64, 103, 46, 170, 208, 164, 202, 75, 168, 92, 171, 81, 170, 178, 141, 46, 201, 225, 107, 84, 178, 189, 239, 194, 19, 141, 51, 236, 18, 208, 116, 79, 238, 100, 227, 107, 60, 158, 153, 48, 251, 46, 131, 25, 24, 146, 179, 162, 9, 28, 204, 253, 122, 252, 223, 248, 188, 154, 126, 16, 68, 142, 217, 92, 36, 88, 111, 110, 170, 255, 162, 251, 145, 179, 125, 253, 158, 55, 56, 197, 167, 167, 197, 227, 73, 42, 128, 4, 232, 126, 3, 240, 31, 132, 14, 181, 137, 192, 2, 112]

