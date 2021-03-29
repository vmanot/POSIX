//
// Copyright (c) Vatsal Manot
//

import Darwin
import Foundation
import Swallow

public struct POSIXThread: Initiable, MutableWrapper {
    public typealias Value = pthread_t?

    public static var current: POSIXThread {
        return .init(pthread_self())
    }

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }

    public init() {
        self.value = nil
    }
}

extension POSIXThread: POSIXSynchronizationPrimitive {
    static var startRoutineWithObjCBlock: (@convention(c) (UnsafeMutableRawPointer) -> UnsafeMutableRawPointer?) = {
        (-*>$0 as (@convention(block) () -> ()))()

        Unmanaged<AnyObject>.release(-*>$0)

        return nil
    }

    public mutating func construct() throws {
        throw EmptyError()
    }

    public mutating func construct(with parameters: (attributes: POSIXThreadAttributes, routine: AnyFunction<Void, Void>)) throws {
        let block: (@convention(block) () -> ()) = { parameters.routine.value(()) }

        Unmanaged<AnyObject>.retain(-*>block)

        try pthread_try({ pthread_create(&value, parameters.attributes.value, POSIXThread.startRoutineWithObjCBlock, -*>block) })
    }

    public mutating func destruct() throws {
        throw EmptyError()
    }
}

extension POSIXThread {
    public static var concurrencyLevel: Int {
        get {
            return .init(pthread_getconcurrency())
        } set {
            pthread_force_try({ pthread_setconcurrency(.init(newValue)) })
        }
    }
}

extension POSIXThread {
    public func cancel() throws {
        try pthread_try({ pthread_cancel(try value.unwrap()) })
    }

    public func detach() throws {
        try pthread_try({ pthread_detach(try value.unwrap()) })
    }

    public static func exit<T>(_ x: inout T) throws {
        pthread_exit(&x)
    }

    public static func exit() throws {
        pthread_exit(nil)
    }

    public static func join(_ thread: POSIXThread) throws {
        try pthread_try({ pthread_join(try thread.value.unwrap(), nil) })
    }

    public func join()  throws {
        try pthread_try({ pthread_join(try value.unwrap(), nil) })
    }

    public func kill(_ code: POSIXResultCode = .success) throws {
        try pthread_try({ pthread_kill(try value.unwrap(), code.rawValue) })
    }

    public static func yield() {
        pthread_yield_np()
    }
}

// MARK: - Conformances -

extension POSIXThread: CustomStringConvertible {
    public var description: String {
        return describe(name)
    }
}

extension POSIXThread: Equatable {
    public static func == (lhs: POSIXThread, rhs: POSIXThread) -> Bool {
        return !(pthread_equal(lhs.value, rhs.value) == 0)
    }
}

extension POSIXThread: Named {
    public var name: String {
        guard let value = value else {
            return .init()
        }

        return String(managedUTF8String: UnsafeRawBufferPointer.allocate(capacity: 64)
            .applyingSelfOn({
                try! pthread_getname_np(value, $0.baseAddress!.mutableRepresentation.assumingMemoryBound(to: <<infer>>), $0.count).throwingAsPOSIXErrorIfNecessary()
            }).baseAddress).initializedIfNil
    }

    public static var name: String {
        get {
            return current.name
        } set {
            pthread_force_try({ pthread_setname_np(newValue) })
        }
    }
}
