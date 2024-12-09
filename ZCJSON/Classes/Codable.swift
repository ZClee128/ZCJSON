//
//  CodableProtocol.swift
//  ZCJSON
//
//  Created by lzc on 2022/6/27.
//

import Foundation

public extension Encodable {
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch  {
            return nil
        }
   }
    
    func toJsonString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

public extension Data {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        do {
            // 使用 JSONDecoder 解码，直接支持数组或对象
            let model = try JSONDecoder().decode(type, from: self)
            return model
        } catch {
            print("JSON decoding failed: \(error)")
            return nil
        }
    }
}

public extension String {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.asDecodable(type)
    }
}

public extension Dictionary {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return nil }
        return data.asDecodable(type)
    }
}

public extension NSDictionary {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return nil }
        return data.asDecodable(type)
    }
}

public extension NSData {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        return (self as Data).asDecodable(type)
    }
}
