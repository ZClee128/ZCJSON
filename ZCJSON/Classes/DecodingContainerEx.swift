//
//  CodableProtocol.swift
//  ZCJSON
//
//  Created by lzc on 2022/6/27.
//

import Foundation
import UIKit

extension KeyedDecodingContainer {
    public func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T? where T: RawRepresentable, T.RawValue: Decodable {
        guard
            let rawValue = try decodeIfPresent(type.RawValue.self, forKey: key),
            let value = T(rawValue: rawValue)
        else {
            return nil
        }

        return value
    }
    
    public func decodeIfPresent(_ type: URL.Type, forKey key: Key) throws -> URL? {
        guard
            let string = try decodeIfPresent(String.self, forKey: key),
            let url = URL(string: string)
        else {
            return nil
        }
        
        return url
    }
    
    public func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        if let bool = try? decode(type, forKey: key) {
            return bool
        } else if let int = try? decode(Int.self, forKey: key) {
            return Bool(exactly: int as NSNumber)
        } else {
            return nil
        }
    }
    
    public func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        if let int = try? decode(Int64.self, forKey: key) {
            return Int(int)
        } else if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        } else {
            return nil
        }
    }
    
    public func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
        if let float = try? decode(type, forKey: key) {
            return float
        } else if let value = try? decode(String.self, forKey: key) {
            return Float(value)
        } else {
            return nil
        }
    }
    
    public func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        if let double = try? decode(type, forKey: key) {
            return double
        } else if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        } else {
            return nil
        }
    }
    
    
    public func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        if let str = try? decode(type, forKey: key) {
            return str
        } else if let int = try? decodeNil(Int.self, forKey: key) {
            return String(int)
        } else if let dic = try? decodeIfPresent([String: Any].self, forKey: key) {
            if (!JSONSerialization.isValidJSONObject(dic)) {
                print("无法解析出JSONString")
                return nil
            }
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: [.fragmentsAllowed,.prettyPrinted]), let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue) as String? {
                return JSONString
            }
            return nil
        } else {
            return nil
        }
    }
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        if type == CGFloat.self {
            guard let float = try decodeIfPresent(Double.self, forKey: key) else {
                return nil
            }
            return CGFloat(float) as? T
        } else if type == String.self {
            guard let str = try decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            return str as? T
        } else {
            return try? decode(type, forKey: key)
        }
    }
    
    public func decode<T>(_ type: T.Type, forKey key: Self.Key) throws -> T where T: CaseDefaultsFirst {
        guard
            let rawValue = try decodeIfPresent(type.RawValue.self, forKey:key),
            let value = T(rawValue: rawValue)
        else {
            return T.allCases.first!
        }

        return value
    }
    
    public func decode(_ type: Int.Type, forKey key: Self.Key) throws -> Int {
        guard
            let value = try decodeIfPresent(Int.self, forKey: key)
        else {
            return 0
        }
        return value
    }
    
    
    public func decodeNil(_ type: Int.Type, forKey key: Self.Key) throws -> Int? {
        guard
            let value = try decodeIfPresent(Int.self, forKey: key)
        else {
            return nil
        }
        return value
    }

    public func decode<T>(_ type: T.Type, forKey key: Self.Key) throws -> T where T: DefaultValue {
        return T.defaultValue as! T
    }
    
}
