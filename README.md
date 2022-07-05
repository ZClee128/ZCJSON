# ZCJSON

[![CI Status](https://img.shields.io/travis/18162711/ZCJSON.svg?style=flat)](https://travis-ci.org/18162711/ZCJSON)
[![Version](https://img.shields.io/cocoapods/v/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![License](https://img.shields.io/cocoapods/l/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![Platform](https://img.shields.io/cocoapods/p/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)

## Example

### Dictionary->model(底层方法)

```swift
let decoder = JSONDecoder()
try decoder.decode(Model.self, from: data)

```

### Dictionary转模型(封装方法)
```swift
let model =  data.asDecodable(Model.self)
```

### model->json 
```swift
model.toJSONString()
```

### Enum

对于枚举类型请遵循 `CaseDefaultsFirst` 协议，如果解析失败会返回默认 case

**Note: 枚举使用强类型解析，关联类型和数据类型不一致不会进行类型转换，会解析为默认第一个case**

```swift
enum Enum: Int, Codable, CaseDefaultsFirst {
    case case1
    case case2
    case case3
    
}
```


```
因为Codable不支持模型默认值，所以扩展一个解析类 DefaultValueDecoder
用法如下：
    @Default<Bool.True> var translatSuccess: Bool
    只要遵循DefaultValue这个协议就可以
    
```

## 可以解析Any
```swift
struct DicModel: Codable {
    var data: [String: Any]?
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
//
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String: Any].self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data ?? [:], forKey: .data)
    }
}

struct ArrModel: Codable {
    var data: [Any]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
//
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Any].self, forKey: .config)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data ?? [], forKey: .data)
    }
}
```
## 实战
```swift
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
    
    init() {

    }

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

```

ZCJSON is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZCJSON'
```

## Author

ZClee128, 876231865@qq.com

## License

ZCJSON is available under the MIT license. See the LICENSE file for more info.
