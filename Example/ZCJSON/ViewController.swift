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

@zcCodable
@zcMirror
final class TestModel: Codable {
    
    var boolean: CGFloat?
    @zcAnnotation(key: ["data", "DataModel"])
    var use: DataModel
//    var double: String?
//    var nested: Nested?
//    let data: [String: Any]
}
@zcCodable
class DataModel: Codable {
    var salt: String?
    var expires_time: Int?
    var uid: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let json = #"""
               {
                "boolean": "4",
                "status" : 0,
                "data" : {
                 "cat" : {
                         "salt" : "e7f820",
                         "expires_time" : 0,
                         "uid" : "",
                        }
                 }
             }
        """#.data(using: .utf8)!
        
        do {
            var model = json.asDecodable(DataModel.self, designatedPath: "data.cat")
            debugPrint("model:", model?.salt)
//            debugPrint("use:", model?.use)
//            debugPrint("dict:", model?.data)
//            if let use = model?.use {
//                print("use: \(use)")
//            }
            
        } catch {
            debugPrint(error)
        }
    }
}
