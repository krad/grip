import XCTest
@testable import grip

class VideoSampleTests: XCTestCase {
    
    struct SamplePacket: BinaryEncodable {
        var type: PacketType                = .video
        var isSync: Bool                    = true
        var dependsOnOther: Bool            = false
        var earlierDisplayTimesAllows: Bool = false
        
        var duration: Int64      = 0
        var timescale: UInt32    = 0
        
        var data: [UInt8]
        
        init(duration: Int64, timescale: UInt32, data: [UInt8]) {
            self.duration   = duration
            self.timescale  = timescale
            self.data       = data
        }
    }
    
    func test_that_we_can_create_a_video_sample_from_bytes() {
        
        let packet = SamplePacket(duration: 2400, timescale: 30000, data: videoPayload)
        let bytes  = try? BinaryEncoder.encode(packet)
        XCTAssertNotNil(bytes)
        
        /// BinaryEncodable prefixes a 32 bit size
        let sampleBytes = Array(bytes![4..<bytes!.count])
        
        let sample = VideoSample(bytes: sampleBytes)
        XCTAssertEqual(sample.type, .video)
        XCTAssertEqual(sample.isSync, true)
        XCTAssertEqual(sample.dependsOnOthers, false)
        XCTAssertEqual(sample.duration, 2400)
        XCTAssertEqual(sample.timescale, 30000)
        XCTAssertEqual(sample.durationSeconds, 0.08)
        
        XCTAssertEqual(2, sample.nalus.count)
        XCTAssertEqual(NALUType.SEI, sample.nalus.first!.type)
        XCTAssertEqual(NALUType.IDR, sample.nalus.last!.type)
    }
    
    func test_that_we_can_create_a_stream_type_from_bytes() {
        let av: StreamType = [.audio, .video]
        let avBytes = try? BinaryEncoder.encode(av)
        XCTAssertNotNil(avBytes)
        
        let parsedAv = StreamType.parse(Array(avBytes![3..<avBytes!.count]))
        XCTAssertNotNil(parsedAv)
        XCTAssertEqual(parsedAv, [.audio, .video])
        
        let a: StreamType = [.audio]
        let aBytes = try? BinaryEncoder.encode(a)
        XCTAssertNotNil(aBytes)
        
        let parsedA = StreamType.parse(Array(aBytes![3..<aBytes!.count]))
        XCTAssertNotNil(parsedA)
        XCTAssertEqual(parsedA, [.audio])
        
        let v: StreamType = [.video]
        let vBytes = try? BinaryEncoder.encode(v)
        XCTAssertNotNil(vBytes)
        
        let parsedV = StreamType.parse(Array(vBytes![3..<vBytes!.count]))
        XCTAssertNotNil(parsedV)
        XCTAssertEqual(parsedV, [.video])
        
        let randomBytes: [UInt8] = [0, 0, 0, 5, 44]
        let parsedRandom         = StreamType.parse(randomBytes)
        XCTAssertNil(parsedRandom)
    }
    
}

let videoPayload: [UInt8] = [0, 0, 0, 20, 6, 5, 16, 185, 237, 185, 48, 93, 33, 75, 113, 131, 113, 44, 16, 163, 20, 187, 41, 128, 0, 0, 15, 53, 37, 184, 0, 64, 0, 3, 127, 255, 255, 15, 24, 80, 0, 17, 1, 240, 132, 191, 255, 96, 248, 66, 127, 254, 89, 252, 33, 255, 236, 26, 252, 156, 146, 73, 44, 154, 147, 132, 53, 254, 139, 252, 146, 40, 66, 81, 170, 125, 185, 80, 253, 171, 48, 132, 64, 167, 254, 191, 194, 22, 33, 207, 255, 216, 112, 132, 225, 64, 1, 170, 128, 251, 255, 228, 200, 160, 146, 40, 66, 85, 251, 255, 228, 145, 73, 42, 147, 82, 72, 161, 9, 76, 16, 6, 191, 255, 147, 147, 80, 132, 159, 160, 31, 254, 16, 144, 95, 246, 127, 242, 68, 25, 146, 69, 168, 66, 112, 156, 65, 30, 119, 244, 95, 194, 25, 3, 159, 233, 119, 228, 145, 50, 80, 222, 9, 57, 170, 72, 135, 37, 8, 121, 44, 80, 201, 35, 147, 114, 98, 178, 74, 128, 100, 158, 16, 190, 108, 255, 248, 67, 255, 254, 202, 78, 78, 16, 214, 223, 255, 228, 212, 156, 33, 175, 255, 246, 194, 20, 76, 178, 251, 86, 95, 146, 148, 147, 10, 203, 18, 32, 7, 132, 45, 80, 191, 255, 146, 69, 8, 107, 255, 95, 194, 18, 175, 244, 95, 225, 9, 150, 191, 255, 146, 212, 33, 40, 187, 118, 26, 181, 109, 223, 249, 34, 20, 33, 18, 78, 129, 53, 65, 250, 31, 240, 134, 169, 178, 255, 252, 156, 156, 33, 155, 253, 135, 97, 252, 193, 128, 228, 132, 6, 147, 33, 8, 213, 255, 254, 225, 9, 67, 234, 213, 209, 127, 252, 33, 71, 82, 159, 178, 161, 178, 254, 16, 181, 254, 203, 252, 149, 8, 81, 127, 167, 255, 201, 66, 28, 8, 97, 65, 170, 191, 255, 146, 156, 152, 135, 9, 35, 146, 80, 176, 143, 130, 16, 186, 63, 255, 228, 150, 73, 36, 228, 184, 66, 85, 252, 234, 127, 228, 228, 145, 73, 44, 147, 41, 39, 82, 68, 41, 44, 80, 100, 181, 36, 178, 82, 146, 148, 147, 41, 39, 82, 106, 77, 73, 32, 185, 39, 80, 133, 175, 255, 29, 136, 248, 67, 255, 254, 220, 33, 255, 255, 164, 78, 16, 152, 105, 51, 181, 235, 254, 75, 52, 2, 18, 147, 178, 218, 215, 156, 223, 194, 31, 255, 209, 112, 135, 244, 95, 252, 146, 23, 146, 97, 89, 49, 89, 44, 46, 160, 38, 228, 145, 201, 184, 66, 44, 64, 2, 195, 255, 255, 37, 66, 18, 181, 211, 255, 240, 135, 242, 34, 255, 225, 15, 250, 7, 211, 246, 137, 201, 201, 194, 31, 255, 250, 65, 13, 127, 255, 106, 16, 145, 126, 159, 254, 16, 215, 255, 191, 112, 134, 191, 127, 252, 154, 132, 37, 37, 19, 255, 141, 162, 126, 77, 66, 25, 128, 0, 58, 127, 218, 248, 66, 67, 8, 15, 255, 217, 51, 146, 133, 201, 98, 124, 178, 41, 41, 66, 19, 133, 173, 31, 251, 63, 146, 80, 237, 88, 145, 74, 16, 139, 94, 191, 254, 16, 209, 255, 235, 240, 135, 254, 131, 255, 8, 73, 254, 191, 92, 148, 164, 193, 172, 158, 16, 156, 127, 61, 111, 255, 194, 27, 10, 255, 255, 132, 59, 255, 255, 8, 76, 33, 255, 245, 252, 145, 78, 72, 145, 47, 38, 20, 120, 124, 72, 56, 157, 62, 159, 254, 63, 57, 31, 109, 191, 252, 156, 33, 227, 201, 63, 255, 225, 15, 255, 252, 169, 9, 194, 31, 215, 255, 132, 61, 11, 255, 242, 114, 112, 132, 193, 65, 95, 175, 95, 78, 74, 14, 131, 196, 149, 66, 20, 191, 79, 253, 138, 78, 75, 80, 132, 179, 253, 127, 228, 145, 66, 18, 137, 195, 251, 116, 111, 242, 72, 164, 165, 8, 98, 255, 101, 254, 156, 146, 11, 146, 148, 147, 136, 242, 82, 146, 212, 147, 169, 36, 82, 75, 8, 127, 173, 130, 249, 161, 146, 32, 92, 154, 146, 89, 45, 136, 33, 127, 255, 233, 132, 36, 10, 52, 255, 251, 225, 9, 66, 192, 9, 5, 47, 255, 225, 12, 9, 155, 72, 108, 244, 237, 254, 203, 8, 224, 99, 62, 245, 95, 252, 33, 255, 250, 126, 16, 255, 255, 163, 147, 146, 104, 67, 41, 95, 237, 208, 116, 94, 16, 159, 255, 229, 252, 33, 70, 14, 255, 255, 72, 149, 8, 74, 173, 21, 39, 255, 225, 12, 193, 131, 255, 245, 169, 34, 20, 150, 161, 9, 79, 223, 255, 248, 66, 151, 245, 255, 132, 42, 104, 127, 255, 36, 166, 228, 153, 73, 106, 75, 82, 106, 73, 20, 150, 46, 73, 148, 33, 56, 195, 38, 95, 255, 78, 73, 6, 12, 139, 106, 74, 23, 36, 234, 16, 148, 208, 209, 127, 252, 156, 156, 33, 32, 88, 16, 128, 127, 245, 217, 100, 153, 73, 97, 18, 235, 2, 19, 140, 178, 255, 254, 228, 184, 67, 8, 137, 210, 255, 233, 175, 38, 32, 0, 88, 39, 39, 39, 36, 138, 16, 195, 228, 127, 254, 211, 120, 66, 83, 144, 127, 208, 127, 194, 31, 253, 44, 195, 126, 78, 16, 210, 255, 253, 56, 67, 253, 124, 100, 145, 15, 201, 201, 132, 71, 56, 72, 165, 37, 168, 232, 144, 93, 103, 199, 255, 179, 242, 114, 112, 134, 111, 251, 18, 118, 63, 201, 74, 16, 181, 253, 7, 255, 8, 82, 94, 191, 252, 33, 107, 246, 95, 249, 36, 80, 132, 64, 195, 47, 254, 159, 146, 139, 129, 24, 240, 119, 194, 116, 90, 31, 255, 29, 24, 118, 123, 255, 127, 36, 162, 228, 161, 114, 78, 56, 32, 97, 10, 22, 175, 255, 248, 66, 127, 232, 255, 228, 228, 138, 10, 40, 9, 106, 73, 84, 154, 143, 148, 48, 101, 169, 233, 167, 255, 112, 134, 190, 203, 255, 147, 82, 97, 220, 176, 67, 2, 206, 168, 255, 246, 210, 194, 51, 18, 250, 127, 254, 16, 148, 72, 7, 62, 203, 255, 8, 68, 10, 31, 255, 219, 194, 17, 101, 167, 254, 180, 147, 194, 18, 37, 255, 175, 194, 18, 208, 191, 255, 132, 63, 235, 255, 37, 97, 11, 253, 63, 252, 33, 64, 210, 98, 3, 255, 215, 194, 20, 35, 157, 127, 252, 33, 75, 250, 127, 242, 98, 79, 8, 79, 255, 250, 44, 155, 146, 98, 233, 44, 156, 33, 42, 255, 236, 95, 37, 56, 66, 192, 174, 116, 127, 244, 252, 147, 5, 132, 132, 16, 156, 64, 3, 137, 213, 54, 218, 79, 254, 74, 82, 92, 177, 70, 96, 150, 35, 132, 145, 73, 138, 201, 138, 194, 17, 191, 255, 190, 77, 73, 20, 20, 104, 73, 28, 33, 22, 30, 0, 98, 159, 253, 124, 146, 169, 36, 49, 4, 146, 4, 202, 121, 167, 42, 48, 132, 160, 157, 241, 142, 118, 242, 169, 255, 225, 13, 143, 229, 207, 250, 48, 132, 159, 255, 234, 73, 100, 154, 74, 112, 132, 191, 255, 211, 132, 37, 48, 32, 56, 198, 159, 207, 240, 135, 255, 50, 75, 63, 147, 64, 65, 15, 255, 163, 249, 34, 2, 138, 2, 98, 228, 149, 73, 48, 86, 196, 33, 22, 21, 88, 239, 253, 126, 77, 201, 16, 228, 164, 137, 97, 134, 64, 140, 224, 96, 216, 255, 244, 254, 16, 181, 95, 255, 228, 212, 154, 147, 132, 63, 216, 191, 240, 140, 134, 255, 101, 255, 132, 34, 5, 255, 247, 249, 49, 89, 44, 80, 1, 146, 65, 88, 66, 61, 143, 47, 251, 181, 249, 50, 48, 74, 25, 144, 147, 57, 49, 46, 4, 108, 71, 54, 147, 233, 255, 132, 39, 11, 128, 1, 0, 64, 191, 244, 235, 185, 36, 82, 90, 132, 45, 126, 53, 167, 233, 249, 36, 144, 132, 191, 255, 204, 53, 36, 140, 4, 73, 36, 150, 16, 255, 250, 63, 146, 73, 34, 100, 146, 16, 151, 233, 255, 242, 69, 10, 48, 132, 162, 44, 127, 217, 253, 162, 106, 72, 165, 8, 70, 138, 7, 251, 95, 242, 89, 121, 34, 28, 152, 172, 116, 224, 163, 169, 245, 255, 201, 42, 146, 69, 36, 178, 114, 114, 113, 217, 191, 253, 101, 126, 201, 66, 17, 131, 149, 63, 255, 242, 72, 20, 89, 22, 113, 41, 18, 76, 161, 8, 214, 59, 63, 255, 201, 106, 75, 104, 33, 254, 82, 95, 248, 66, 101, 254, 191, 228, 144, 92, 152, 185, 39, 17, 225, 9, 87, 229, 149, 206, 95, 249, 36, 82, 90, 132, 53, 217, 210, 255, 225, 11, 217, 255, 254, 73, 33, 10, 127, 253, 23, 121, 57, 45, 194, 18, 245, 99, 255, 242, 110, 16, 198, 80, 127, 253, 22, 73, 5, 1, 132, 37, 19, 135, 246, 46, 202, 182, 201, 65, 121, 8, 146, 5, 116, 8, 74, 37, 255, 253, 124, 148, 228, 161, 10, 130, 98, 131, 37, 169, 37, 82, 114, 114, 114, 112, 135, 181, 255, 248, 67, 1, 43, 90, 126, 123, 41, 163, 255, 31, 128, 99, 63, 158, 106, 127, 255, 147, 20, 0, 100, 197, 0, 6, 77, 66, 20, 62, 153, 123, 255, 252, 33, 127, 254, 223, 132, 63, 243, 173, 254, 78, 73, 148, 145, 74, 73, 197, 201, 139, 146, 36, 138, 9, 74, 16, 215, 98, 255, 248, 66, 252, 136, 145, 126, 207, 225, 11, 255, 242, 239, 132, 54, 63, 211, 163, 236, 62, 16, 155, 249, 214, 255, 132, 37, 244, 95, 254, 74, 114, 114, 75, 38, 11, 216, 72, 36, 129, 72, 32, 36, 152, 92, 148, 46, 76, 86, 16, 141, 63, 223, 239, 252, 147, 57, 38, 21, 132, 103, 3, 13, 143, 54, 255, 252, 33, 58, 255, 255, 97, 147, 147, 147, 147, 147, 132, 63, 176, 191, 249, 57, 57, 57, 57, 56, 67, 2, 124, 216, 121, 247, 250, 127, 146, 69, 8, 74, 191, 251, 47, 132, 53, 255, 79, 216, 178, 68, 41, 38, 23, 38, 43, 36, 72, 184, 66, 113, 56, 126, 157, 147, 47, 194, 18, 47, 215, 255, 8, 74, 108, 255, 243, 81, 141, 83, 8, 73, 255, 251, 225, 9, 127, 202, 24, 20, 255, 146, 34, 73, 28, 147, 185, 45, 194, 18, 255, 251, 167, 201, 36, 33, 65, 65, 167, 251, 47, 225, 25, 193, 59, 209, 185, 255, 178, 179, 186, 22, 72, 165, 38, 43, 37, 10, 201, 18, 31, 20, 194, 110, 73, 133, 100, 177, 3, 201, 42, 146, 89, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 48, 75, 224, 226, 72, 164, 149, 66, 31, 191, 255, 132, 38, 95, 255, 237, 146, 40, 86, 89, 196, 121, 39, 10, 72, 33, 9, 86, 199, 250, 119, 249, 36, 51, 1, 10, 25, 66, 253, 151, 247, 146, 65, 89, 56, 66, 82, 144, 252, 229, 255, 242, 72, 225, 8, 185, 209, 255, 211, 246, 48, 132, 207, 251, 23, 252, 151, 36, 181, 16, 164, 177, 48, 0, 9, 34, 20, 146, 138, 50, 76, 228, 137, 18, 242, 91, 146, 71, 37, 136, 30, 16, 137, 39, 223, 255, 228, 228, 228, 228, 228, 228, 228, 228, 228, 228, 228, 228, 228, 144, 38, 28, 225, 53, 36, 176, 132, 203, 255, 237, 114, 68, 11, 146, 197, 100, 177, 70, 73, 212, 148, 164, 162, 242, 88, 144, 121, 34, 156, 145, 50, 83, 147, 112, 132, 175, 255, 251, 201, 110, 16, 148, 249, 235, 95, 248, 66, 97, 65, 175, 253, 126, 75, 55, 38, 39, 132, 152, 92, 150, 40, 194, 17, 32, 226, 47, 255, 251, 201, 24, 228, 144, 86, 16, 132, 66, 213, 255, 94, 223, 38, 161, 13, 127, 236, 43, 47, 39, 39, 39, 39, 39, 38, 164, 228, 165, 37, 169, 57, 58, 160, 51, 233, 129, 11, 93, 159, 246, 254, 78, 73, 12, 160, 145, 2, 178, 72, 43, 36, 234, 16, 139, 28, 16, 31, 253, 11, 225, 10, 95, 255, 183, 132, 44, 18, 209, 171, 143, 111, 125, 107, 194, 25, 179, 255, 66, 79, 201, 16, 40, 199, 196, 132, 5, 83, 153, 150, 125, 255, 242, 76, 228, 167, 36, 174, 16, 149, 247, 99, 244, 47, 225, 13, 255, 247, 245, 8, 98, 246, 190, 215, 248, 67, 38, 81, 255, 254, 72, 133, 37, 139, 146, 66, 16, 66, 50, 151, 255, 214, 203, 121, 49, 89, 38, 21, 132, 34, 196, 0, 255, 250, 254, 16, 181, 178, 244, 47, 249, 53, 39, 39, 39, 39, 8, 96, 153, 202, 167, 219, 247, 233, 201, 20, 46, 75, 23, 37, 41, 34, 212, 146, 40, 66, 85, 255, 251, 5, 132, 105, 15, 178, 255, 233, 132, 45, 126, 135, 223, 242, 72, 164, 204, 160, 145, 65, 69, 145, 39, 10, 218, 146, 65, 18, 36, 137, 9, 66, 192, 172, 92, 51, 137, 132, 101, 30, 198, 85, 31, 255, 38, 66, 8, 67, 84, 255, 255, 147, 146, 33, 201, 185, 55, 36, 174, 76, 109, 48, 74, 16, 9, 4, 33, 139, 246, 255, 250, 146, 65, 112, 132, 226, 254, 223, 255, 36, 202, 74, 23, 8, 78, 43, 216, 47, 255, 146, 97, 89, 39, 20, 25, 37, 80, 133, 175, 251, 47, 228, 228, 225, 15, 255, 253, 176, 134, 9, 150, 85, 159, 254, 223, 36, 197, 228, 167, 36, 130, 176, 132, 226, 7, 255, 175, 242, 82, 132, 39, 95, 235, 254, 16, 181, 255, 251, 228, 160, 37, 105, 63, 56, 35, 96, 77, 236, 94, 81, 16, 32, 115, 106, 118, 252, 222, 188, 35, 48, 81, 107, 246, 191, 240, 132, 224, 65, 160, 111, 6, 212, 244, 255, 249, 49, 64, 6, 78, 16, 255, 101, 255, 147, 147, 147, 132, 63, 239, 255, 39, 39, 36, 80, 129, 192, 133, 136, 115, 255, 191, 65, 146, 64, 179, 226, 78, 33, 194, 72, 33, 194, 72, 161, 8, 144, 172, 199, 255, 191, 37, 11, 147, 82, 80, 185, 38, 114, 78, 40, 194, 49, 96, 113, 218, 250, 1, 162, 191, 248, 67, 93, 23, 255, 201, 201, 201, 201, 201, 16, 23, 166, 2, 17, 34, 64, 61, 127, 233, 124, 155, 146, 71, 36, 64, 133, 65, 37, 23, 36, 162, 228, 181, 37, 169, 57, 57, 34, 20, 33, 19, 254, 191, 79, 39, 39, 39, 39, 39, 39, 39, 8, 127, 253, 129, 252, 156, 147, 11, 132, 49, 60, 255, 162, 162, 242, 74, 164, 153, 73, 40, 156, 9, 155, 9, 32, 185, 53, 37, 139, 146, 65, 114, 80, 172, 33, 26, 21, 0, 87, 255, 239, 146, 69, 36, 170, 77, 73, 201, 201, 194, 56, 46, 33, 38, 125, 62, 247, 240, 135, 255, 191, 228, 203, 201, 35, 146, 97, 89, 49, 70, 73, 212, 150, 164, 212, 33, 107, 217, 127, 248, 67, 95, 255, 222, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 78, 72, 165, 37, 136, 134, 2, 73, 212, 147, 41, 41, 73, 40, 139, 4, 152, 86, 73, 69, 25, 44, 79, 147, 16, 242, 80, 151, 146, 133, 25, 39, 19, 160, 66, 81, 161, 132, 223, 253, 126, 78, 16, 215, 178, 211, 255, 132, 63, 255, 163, 228, 225, 31, 255, 55, 252, 33, 134, 217, 167, 255, 191, 147, 114, 72, 228, 145, 212, 130, 228, 148, 81, 146, 81, 114, 72, 46, 16, 156, 47, 239, 221, 127, 201, 112, 132, 139, 255, 127, 201, 106, 16, 191, 255, 235, 38, 78, 78, 78, 78, 78, 78, 16, 195, 118, 163, 142, 164, 243, 255, 132, 53, 254, 255, 228, 153, 73, 74, 16, 181, 246, 46, 191, 201, 68, 72, 74, 80, 132, 72, 159, 255, 251, 5, 112, 132, 80, 116, 83, 63, 254, 249, 48, 162, 128, 150, 39, 201, 66, 178, 88, 151, 146, 103, 36, 226, 140, 146, 168, 66, 115, 103, 255, 223, 38, 164, 212, 156, 145, 66, 108, 18, 212, 35, 40, 59, 231, 167, 255, 201, 33, 216, 46, 32, 112, 150, 40, 12, 150, 164, 165, 37, 169, 34, 5, 194, 17, 162, 128, 15, 253, 127, 132, 36, 95, 255, 234, 73, 100, 228, 225, 13, 108, 191, 255, 39, 39, 39, 39, 8, 118, 95, 255, 194, 31, 255, 208, 185, 34, 20, 33, 98, 255, 232, 95, 201, 139, 147, 80, 134, 189, 23, 255, 147, 19, 227, 168, 58, 20, 62, 247, 251, 211, 82, 33, 147, 23, 37, 138, 50, 98, 228, 148, 86, 90, 7, 31, 146, 212, 147, 169, 53, 38, 164, 225, 28, 10, 172, 17, 44, 178, 191, 255, 146, 97, 35, 129, 9, 195, 240, 34, 253, 191, 250, 136, 59, 4, 148, 64, 10, 128, 132, 171, 253, 151, 248, 67, 54, 127, 245, 242, 76, 39, 132, 153, 73, 98, 178, 68, 138, 0, 194, 22, 186, 247, 255, 147, 80, 135, 239, 255, 228, 225, 12, 140, 125, 63, 252, 156, 156, 156, 156, 156, 156, 147, 40, 66, 194, 240, 0, 47, 253, 150, 185, 53, 36, 138, 16, 137, 33, 5, 255, 209, 117, 201, 20, 170, 81, 164, 201, 44, 64, 121, 38, 20, 100, 152, 92, 146, 138, 201, 98, 178, 74, 36, 121, 36, 20, 100, 149, 66, 19, 175, 255, 101, 228, 212, 33, 175, 254, 223, 199, 100, 94, 247, 255, 242, 72, 50, 128, 146, 5, 213, 8, 68, 142, 211, 234, 205, 127, 78, 73, 20, 148, 39, 201, 32, 172, 152, 172, 148, 43, 36, 162, 140, 145, 42, 16, 163, 4, 1, 255, 247, 228, 185, 57, 57, 41, 73, 66, 120, 16, 148, 217, 255, 166, 190, 78, 78, 78, 78, 16, 153, 127, 161, 118, 188, 33, 139, 255, 244, 94, 74, 80, 132, 226, 57, 163, 255, 249, 38, 82, 106, 77, 73, 66, 153, 40, 86, 76, 66, 193, 40, 86, 73, 196, 188, 148, 43, 81, 34, 60, 146, 41, 41, 73, 41, 57, 37, 132, 113, 196, 22, 83, 67, 236, 191, 37, 57, 45, 194, 24, 60, 255, 255, 100, 192, 109, 228, 152, 37, 85, 193, 34, 5, 100, 220, 147, 137, 121, 38, 21, 146, 113, 37, 65, 49, 3, 201, 42, 132, 37, 95, 255, 233, 147, 147, 132, 48, 174, 159, 74, 207, 236, 174, 72, 133, 8, 78, 189, 127, 252, 33, 107, 255, 101, 103, 228, 228, 228, 225, 9, 7, 145, 63, 178, 158, 29, 188, 152, 184, 66, 215, 209, 249, 148, 126, 16, 176, 254, 51, 244, 7, 253, 100, 138, 23, 8, 78, 191, 255, 220, 152, 158, 18, 97, 89, 40, 86, 74, 21, 147, 23, 36, 226, 94, 72, 129, 88, 66, 17, 15, 25, 59, 255, 248, 66, 66, 122, 127, 255, 147, 80, 133, 8, 195, 175, 255, 146, 112, 137, 67, 97, 14, 145, 59, 43, 47, 178, 178, 242, 74, 228, 136, 58, 130, 88, 172, 148, 40, 201, 66, 153, 37, 11, 166, 68, 197, 100, 138, 114, 74, 37, 12, 4, 145, 34, 0, 121, 37, 82, 114, 114, 112, 135, 251, 255, 228, 138, 19, 192, 132, 90, 253, 191, 252, 33, 68, 202, 125, 59, 127, 225, 11, 32, 0, 7, 253, 173, 151, 114, 112, 135, 255, 254, 228, 136, 19, 161, 40, 92, 150, 161, 8, 149, 255, 236, 125, 201, 20, 46, 73, 84, 33, 175, 223, 255, 8, 88, 202, 15, 235, 254, 72, 129, 89, 49, 89, 49, 88, 66, 36, 62, 12, 158, 159, 255, 8, 74, 14, 130, 202, 171, 216, 137, 40, 255, 201, 48, 151, 9, 66, 153, 36, 114, 88, 172, 152, 151, 9, 98, 94, 76, 74, 193, 40, 86, 75, 21, 147, 20, 100, 167, 8, 78, 43, 237, 255, 249, 36, 114, 80, 163, 37, 169, 37, 17, 228, 149, 73, 201, 201, 201, 194, 24, 116, 0, 83, 62, 223, 253, 34, 69, 11, 132, 34, 204, 32, 54, 190, 154, 255, 8, 107, 198, 18, 125, 26, 31, 249, 56, 67, 95, 54, 127, 248, 66, 64, 172, 0, 11, 127, 166, 206, 133, 225, 26, 7, 188, 255, 162, 252, 148, 161, 8, 145, 60, 245, 253, 141, 147, 104, 82, 68, 11, 146, 80, 174, 160, 132, 171, 255, 211, 98, 92, 145, 66, 178, 88, 145, 194, 76, 43, 37, 148, 208, 66, 55, 255, 251, 56, 67, 62, 85, 187, 255, 242, 110, 73, 28, 152, 151, 9, 51, 146, 81, 89, 38, 114, 74, 228, 196, 176, 38, 228, 176, 187, 226, 110, 75, 114, 80, 89, 161, 44, 71, 132, 37, 95, 244, 172, 254, 16, 194, 220, 39, 254, 195, 71, 240, 135, 255, 251, 228, 228, 228, 228, 212, 33, 153, 71, 255, 246, 68, 136, 23, 36, 76, 156, 156, 156, 146, 40, 66, 97, 127, 255, 208, 225, 9, 87, 254, 215, 228, 165, 36, 170, 73, 20, 146, 169, 48, 248, 42, 18, 49, 203, 131, 84, 161, 24, 208, 66, 174, 246, 145, 74, 161, 63, 211, 248, 66, 95, 252, 171, 126, 16, 223, 254, 223, 228, 167, 37, 185, 55, 36, 142, 77, 201, 136, 121, 36, 21, 146, 220, 147, 57, 39, 21, 146, 119, 36, 206, 76, 67, 201, 66, 228, 137, 80, 134, 182, 72, 95, 183, 248, 67, 95, 103, 255, 201, 194, 31, 253, 255, 147, 147, 132, 51, 2, 0, 255, 232, 127, 8, 99, 64, 136, 247, 255, 225, 15, 146, 159, 219, 249, 56, 67, 82, 103, 255, 240, 135, 255, 254, 121, 18, 33, 73, 32, 184, 66, 44, 80, 7, 255, 167, 240, 133, 143, 119, 255, 217, 100, 152, 202, 9, 34, 147, 53, 2, 22, 26, 0, 225, 255, 111, 240, 133, 1, 119, 171, 63, 127, 248, 66, 44, 20, 134, 133, 21, 52, 84, 232, 172, 15, 225, 9, 135, 170, 246, 127, 252, 33, 56, 194, 13, 127, 254, 77, 201, 159, 2, 30, 139, 255, 165, 146, 71, 36, 142, 73, 79, 201, 66, 20, 129, 9, 193, 19, 156, 59, 217, 246, 183, 242, 76, 228, 157, 201, 35, 146, 156, 152, 172, 146, 10, 201, 98, 140, 146, 169, 53, 8, 74, 191, 247, 252, 156, 154, 147, 132, 63, 251, 255, 39, 8, 127, 255, 174, 78, 16, 215, 252, 255, 248, 67, 39, 204, 199, 255, 201, 194, 20, 68, 159, 39, 250, 249, 34, 5, 25, 49, 112, 132, 171, 255, 237, 112, 133, 173, 175, 255, 201, 74, 16, 157, 127, 255, 106, 72, 192, 234, 225, 132, 35, 65, 38, 103, 124, 95, 166, 132, 51, 70, 12, 58, 127, 36, 96, 172, 33, 26, 40, 0, 62, 205, 126, 159, 194, 24, 233, 195, 255, 101, 94, 16, 223, 253, 255, 147, 112, 135, 249, 116, 129, 95, 252, 156, 156, 33, 48, 85, 165, 63, 255, 201, 110, 76, 58, 15, 4, 37, 127, 253, 52, 188, 146, 57, 45, 201, 78, 72, 135, 36, 225, 97, 161, 38, 23, 8, 70, 136, 0, 127, 254, 191, 8, 102, 98, 255, 255, 147, 82, 114, 114, 114, 114, 112, 135, 249, 20, 127, 228, 228, 225, 13, 127, 36, 61, 135, 228, 240]
