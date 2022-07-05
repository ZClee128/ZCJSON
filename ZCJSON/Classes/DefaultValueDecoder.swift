//
//  CodableProtocol.swift
//  ZCJSON
//
//  Created by lzc on 2022/6/27.
//

import Foundation

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
public struct Default<T: DefaultValue>: Codable {
    public typealias ValueType = T.Value
    public var wrappedValue: ValueType
    @inline(__always) public init(wrappedValue: ValueType) {
        self.wrappedValue = wrappedValue
    }
    
    @inline(__always) public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
    
    @inline(__always) public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = decodeValue(with: container) ?? T.defaultValue
    }
}

public extension KeyedDecodingContainer {
    @inline(__always) func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
    
}


private func decodeValue<T, U>(with container: SingleValueDecodingContainer, type: U) -> T? where U: BinaryInteger & LosslessStringConvertible {
    if let num = try? container.decode(Int64.self) {
        return U(num) as? T
    } else if let str = try? container.decode(String.self) {
        return U(str) as? T
    } else if let num = try? container.decode(UInt64.self) {
        return U(num) as? T
    }  else if let num = try? container.decode(Double.self) {
        return U(num) as? T
    } else if let bool = try? container.decode(Bool.self) {
        return U(bool ? 1 : 0) as? T
    } else {
        return nil
    }
}

private func decodeValue<T, U>(with container: SingleValueDecodingContainer, type: U) -> T? where U: BinaryFloatingPoint & LosslessStringConvertible {
    if let num = try? container.decode(Int64.self) {
        return U(num) as? T
    } else if let str = try? container.decode(String.self) {
        return U(str) as? T
    } else if let num = try? container.decode(UInt64.self) {
        return U(num) as? T
    } else if let num = try? container.decode(Double.self) {
        return U(num) as? T
    } else if let bool = try? container.decode(Bool.self) {
        return U(bool ? 1 : 0) as? T
    } else {
        return nil
    }
}

private func decodeValue<T: Codable>(with container: SingleValueDecodingContainer) -> T? {
    if let v = try? container.decode(T.self) {
        return v
    } else if T.self == Int.self {
        return decodeValue(with: container, type: Int(0))
    } else if T.self == String.self {
        if let num = try? container.decode(Int64.self) {
            return "\(num)" as? T
        } else if let num = try? container.decode(UInt64.self) {
            return "\(num)" as? T
        }  else if let num = try? container.decode(Double.self) {
            return "\(num)" as? T
        }  else if let num = try? container.decode(Bool.self) {
            return "\(num)" as? T
        }
    } else if T.self == Float.self {
        return decodeValue(with: container, type: Float(0))
    } else if T.self == Bool.self {
        if let num = try? container.decode(Int64.self) {
            return (num != 0) as? T
        } else if let str = try? container.decode(String.self) {
            return Bool(str) as? T
        } else if let num = try? container.decode(UInt64.self) {
            return (num != 0) as? T
        }  else if let num = try? container.decode(Double.self) {
            return (num != 0) as? T
        }
    } else if T.self == UInt.self {
        return decodeValue(with: container, type: UInt(0))
    } else if T.self == Double.self {
        return decodeValue(with: container, type: Double(0))
    } else if T.self == Int8.self {
        return decodeValue(with: container, type: Int8(0))
    } else if T.self == Int16.self {
        return decodeValue(with: container, type: Int16(0))
    } else if T.self == Int32.self {
        return decodeValue(with: container, type: Int32(0))
    } else if T.self == Int64.self {
        return decodeValue(with: container, type: Int64(0))
    } else if T.self == UInt8.self {
        return decodeValue(with: container, type: UInt8(0))
    } else if T.self == UInt16.self {
        return decodeValue(with: container, type: UInt16(0))
    } else if T.self == UInt32.self {
        return decodeValue(with: container, type: UInt32(0))
    } else if T.self == UInt64.self {
        return decodeValue(with: container, type: UInt64(0))
    }
    
    return nil
}


public extension Bool {
    enum False: DefaultValue {
        public static let defaultValue = false
    }
    enum True: DefaultValue {
        public static let defaultValue = true
    }
}

public extension String {
    enum EMPTY: DefaultValue {
        public static let defaultValue = ""
    }
}

public extension Int {
    enum Default: DefaultValue {
        public static let defaultValue = 0
    }
}
