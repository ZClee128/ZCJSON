//
//  ViewController.swift
//  ZCJSON
//
//  Created by lzc on 07/05/2022.
//  Copyright (c) 2022 18162711. All rights reserved.
//

import UIKit
import ZCJSON
import ZCMacro

public enum Nested: String, Codable, ZCCodable {
    public static var defaultValue: Nested {
        return .none
    }
    case none
    case first
    case sencond
    case third
    
    
}
public protocol custom {
    
}

public typealias Codable = Decodable & Encodable 

@zcCodable
final class TestModel: Codable {
    
    var boolean: Int?
//    @zcAnnotation(default: true)
//    var use: Bool
//    var double: String?
//    var nested: Nested?
//    let data: [String: Any]
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let json = #"""
               {
        "boolean": "4",
               "status" : 0,
                "data" : {
                 "salt" : "e7f820",
                 "expires_time" : 0,
                 "uid" : "",
                 }
             }
        """#.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            var model = try decoder.decode(TestModel.self, from: json)
            debugPrint("boolean:", model.boolean)
//            debugPrint("use:", model.use)
//            debugPrint("dict:", model.data)
            
        } catch {
            debugPrint(error)
        }
    }
}
