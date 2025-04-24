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
    func asDecodable<T: Decodable>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        do {
            if let path = designatedPath {
                // 首先解析为 JSON 对象
                let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
                
                // 根据路径获取目标对象
                let targetObject = getObject(from: json, path: path)
                
                // 将目标对象转换为 Data
                let targetData = try JSONSerialization.data(withJSONObject: targetObject, options: .fragmentsAllowed)
                
                // 解码目标对象
                return try JSONDecoder().decode(type, from: targetData)
            } else {
                // 如果没有指定路径，使用原来的方式
                return try JSONDecoder().decode(type, from: self)
            }
        } catch {
            print("JSON decoding failed: \(error)")
            return nil
        }
    }
    
    private func getObject(from json: Any, path: String) -> Any {
        let components = path.components(separatedBy: ".")
        var current: Any = json
        
        for component in components {
            if let dict = current as? [String: Any] {
                current = dict[component] ?? NSNull()
            } else if let array = current as? [Any], let index = Int(component) {
                current = array[index]
            } else {
                return NSNull()
            }
        }
        
        return current
    }
}

public extension String {
    func asDecodable<T: Decodable>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.asDecodable(type, designatedPath: designatedPath)
    }
}

public extension Dictionary {
    func asDecodable<T: Decodable>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return nil }
        return data.asDecodable(type, designatedPath: designatedPath)
    }
}

public extension NSDictionary {
    func asDecodable<T: Decodable>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return nil }
        return data.asDecodable(type, designatedPath: designatedPath)
    }
}

public extension NSData {
    func asDecodable<T: Decodable>(_ type: T.Type, designatedPath: String? = nil) -> T? {
        return (self as Data).asDecodable(type, designatedPath: designatedPath)
    }
}
