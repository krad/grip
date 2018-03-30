import Foundation

public protocol Writeable {
    func write(_ data: Data)
}

public protocol Endable {
    var onEnd: ((Endable) -> Void)? { get set }
    func end()
}
