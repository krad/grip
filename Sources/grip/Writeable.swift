import Foundation

public protocol Writeable {
    func write(_ data: Data)
}

public typealias EndedCallback = (Endable) -> Void

public protocol Endable {
    var onEnd: EndedCallback? { get set }
    func end()
}
