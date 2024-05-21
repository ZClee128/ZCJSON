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

public extension String {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        if let model = try? JSONDecoder().decode(type, from: Data(self.utf8)) {
            return model
        }
        return nil
    }
}

public extension Dictionary {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed), let model = try? JSONDecoder().decode(type, from: data) {
            return model
        }
        return nil
    }
}

public extension NSDictionary {
    
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed), let model = try? JSONDecoder().decode(type, from: data) {
            return model
        }
        return nil
    }
}

public extension Data {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        if let model = try? JSONDecoder().decode(type, from: self) {
            return model
        }
        return nil
    }
}

public extension NSData {
    func asDecodable<T: Decodable>(_ type: T.Type) -> T? {
        if let model = try? JSONDecoder().decode(type, from: self as Data) {
            return model
        }
        return nil
    }
}
