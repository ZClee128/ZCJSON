//
//  CodableProtocol.swift
//  ZCJSON
//
//  Created by lzc on 2022/6/27.
//

import Foundation


public extension Encodable {
    
    func toJSON(using encoder: JSONEncoder = .init()) -> Data? {
        do {
            let data = try encoder.encode(self)
            return data
        } catch  {
            return nil
        }
    }
    
    func toJSONString(using encoder: JSONEncoder = .init()) -> String? {
        guard let data = toJSON(using: encoder) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
