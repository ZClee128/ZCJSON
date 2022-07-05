//
//  ViewController.swift
//  ZCJSON
//
//  Created by lzc on 07/05/2022.
//  Copyright (c) 2022 18162711. All rights reserved.
//

import UIKit
import ZCJSON

public enum Nested: String, Codable, CaseDefaultsFirst {
  
    case none
    case first
    case sencond
    case third
    
    
}

struct TestModel: Codable {
    var boolean: Int?
    @Default<Bool.True>
    var integer: Bool
    var double: String?
    var nested: Nested?
    var data: [String: Any]?
    
//    init() {
//
//    }

    enum CodingKeys: String, CodingKey {
        case data
        case integer
        case boolean
        case double
        case nested
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String: Any].self, forKey: .data)
        integer = try values.decodeIfPresent(Bool.self, forKey: .integer) ?? true
        boolean = try values.decodeIfPresent(Int.self, forKey: .boolean)
        double = try values.decodeIfPresent(String.self, forKey: .double) ?? ""
        nested = try values.decodeIfPresent(Nested.self, forKey: .nested)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(integer, forKey: .integer)
        try container.encodeIfPresent(boolean, forKey: .boolean)
        try container.encodeIfPresent(double, forKey: .double)
        try container.encodeIfPresent(nested, forKey: .nested)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let json = #"""
               {
               "status" : 0,
                "integer": true,
                "data" : {
                 "salt" : "e7f820",
                 "expires_time" : 0,
                 "uid" : "",
                 }
             }
        """#.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(TestModel.self, from: json)
            debugPrint("boolean:", model.boolean)
            debugPrint("nested.a:", model.nested)
            debugPrint("dict:", model.data, model.double, model.integer)
            
        } catch {
            debugPrint(error)
        }
    }
}
