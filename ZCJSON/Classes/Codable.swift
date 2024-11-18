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
            // 将 JSON 数据解析为字典
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
            guard let dictionary = jsonObject as? [String: Any] else {
                return nil
            }
            // 解析 JSON 成模型
            let model = try JSONDecoder().decode(type, from: self)
            return model
        } catch {
            return nil // 解码失败直接返回 nil
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
