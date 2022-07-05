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
    目前只扩展了Bool值，后续需要扩展可以参考DefaultValueDecoder实现
```

## 可以解析Any
```
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

ZCJSON is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZCJSON'
```

## Author

ZClee128, 876231865@qq.com

## License

ZCJSON is available under the MIT license. See the LICENSE file for more info.
