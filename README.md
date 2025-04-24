# ZCJSON

[![CI Status](https://img.shields.io/travis/18162711/ZCJSON.svg?style=flat)](https://travis-ci.org/18162711/ZCJSON)
[![Version](https://img.shields.io/cocoapods/v/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![License](https://img.shields.io/cocoapods/l/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![Platform](https://img.shields.io/cocoapods/p/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)

[中文文档](README_CN.md)

ZCJSON is a powerful JSON parsing library for Swift that extends Codable with additional features like default values, type conversion, and Any type handling.

## Features

- 🎯 Automatic default values for missing fields
- 🔄 String to number conversion
- 📦 Any type handling (dictionaries and arrays)
- 🚫 Field ignoring with annotations
- 👥 Inheritance support
- 🎲 Enum handling with default cases
- 🏗️ Macro support for code generation

## Installation

### CocoaPods

ZCJSON is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'ZCJSON'
```

### Swift Package Manager

ZCJSON supports installation via Swift Package Manager. In Xcode:

1. Select File > Add Packages...
2. Enter the package URL: `https://github.com/ZClee128/ZCJSON.git`
3. Choose version rules (Up to Next Major recommended)
4. Click Add Package

Or add the dependency directly in your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/ZClee128/ZCJSON.git", from: "1.0.0")
]
```

## Usage

### Basic JSON Parsing

```swift
// Dictionary to model
let model = data.asDecodable(Model.self)

// Model to JSON string
model.toJSONString()

// Parse with designated path
let jsonString = """
{
    "code": 200,
    "msg": "success",
    "data": {
        "cat": {
            "id": 12345,
            "name": "Kitty"
        }
    }
}
"""

struct Cat: Codable {
    var id: Int64
    var name: String
}

if let cat = jsonString.asDecodable(Cat.self, designatedPath: "data.cat") {
    print(cat.name) // Prints "Kitty"
}
```

### Default Values

ZCJSON provides default values for missing fields in your JSON:

```swift
struct User: Codable {
    let name: String
    let age: Int  // Will be 0 if missing
    @Default<Bool.False>
    var isActive: Bool  // Will be false if missing
    @Default<Bool.True>
    var isVerified: Bool  // Will be true if missing
}
```

### String to Number Conversion

Automatically converts string numbers to numeric types:

```swift
struct Product: Codable {
    let id: Int        // "123" -> 123
    let price: CGFloat // "99.99" -> 99.99
}
```

### Any Type Handling

Handle dynamic JSON structures with Any type:

```swift
@zcCodable
struct DynamicModel: Codable {
    var data: [String: Any]
    var items: [Any]
}
```

### Field Ignoring

Ignore specific fields during parsing:

```swift
struct User: Codable {
    @zcAnnotation(key: ["password"], ignore: true)
    var password: String = "default"
}
```

### Enum Handling

Handle enums with default cases:

```swift
enum Status: String, Codable, CaseDefaultsFirst {
    case active
    case inactive
    case pending
}

struct TestModel: Codable {
    var status: Status
}

let jsonString = """
{
    "status": "invalid"  // Will default to first case
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.status, .active)  // Defaults to first case
}
```

### Enum with Int Values

Handle enums with integer values:

```swift
enum TestType: Int, Codable, CaseDefaultsFirst {
    case none = -1
    case one = 1
}

struct TestModel: Codable {
    let name: String
    let age: Int
    let type: TestType
}

let jsonString = """
{
    "name": "aa",
    "age": "10",
    "type": 1
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.name, "aa")
    XCTAssertEqual(decoded.age, 10)
    XCTAssertEqual(decoded.type, .one)  // Parses integer value to enum case
}
```

### Inheritance Support

Support for class inheritance in JSON parsing:

```swift
class BaseModel: Codable {
    var name: String
}

@zcInherit
class UserModel: BaseModel {
    var age: Int
}
```

## Advanced Examples

### Complex Model with Multiple Features

```swift
@zcCodable
struct ComplexModel: Codable {
    // Default values
    @Default<Bool.True>
    var isEnabled: Bool
    
    // String to number conversion
    let count: Int
    
    // Any type handling
    var metadata: [String: Any]
    var items: [Any]
    
    // Enum with default case
    var status: Status
    
    // Ignored field
    @zcAnnotation(key: ["internal"], ignore: true)
    var internalData: String = "default"
}
```

## Unit Tests

ZCJSON includes comprehensive unit tests covering:

- ✅ Default value handling
- ✅ Type conversion
- ✅ Any type parsing
- ✅ Field ignoring
- ✅ Inheritance
- ✅ Enum handling

Run tests using `⌘U` or `Product -> Test` to verify functionality.

## Author

ZClee128, 876231865@qq.com

## License

ZCJSON is available under the MIT license. See the LICENSE file for more info.

## Support

If you encounter any parsing issues or have questions, feel free to contact me or join our QQ group: 982321096

## 🧪 单元测试说明

ZCJSON 内置了丰富的单元测试，覆盖常见解析场景，包括但不限于：

- ✅ 字段缺失时默认值解析（Int、Float、Bool、String 等）
- ✅ 字符串转数字：如 `"10"` → `Int`、`CGFloat`、`Double`
- ✅ 支持 `[String: Any]` 和 `[Any]` 混合模型解析
- ✅ `Any` 类型字段容错解析
- ✅ 使用 `@Default` 包装器实现默认值声明式支持
- ✅ 多种基础数值类型扩展：支持 `UInt8/16/32/64`、`Int8/16/32/64`
- ✅ 枚举类型容错解析（`CaseDefaultsFirst`）
- ✅ 字段忽略与字段重命名解析
- ✅ 宏生成的模型与自定义手动实现兼容测试

> 💡 示例：测试文件 `Tests.swift` 中包含了完整的 `asDecodable()` 使用案例，验证 `@zcCodable` 的智能容错行为。

开发者可直接运行 `⌘U` 或 `Product -> Test` 来验证功能稳定性。

## Unit Test Examples

### Default Value Handling

ZCJSON automatically handles missing fields with appropriate default values:

```swift
// Test missing field with default value
struct TestModel: Codable {
    let name: String
    let age: Int  // Will be 0 if missing
}

let jsonString = """
{
    "name": "Alice"
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.name, "Alice")
    XCTAssertEqual(decoded.age, 0)  // Default value for missing field
}
```

### Custom Default Values

You can specify custom default values using `@Default`:

```swift
struct TestModel: Codable {
    let name: String
    let age: CGFloat
    @Default<Bool.False>
    var isStudent: Bool
    @Default<Bool.True>
    var isTeacher: Bool
}

let jsonString = """
{
    "name": "Alice"
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.name, "Alice")
    XCTAssertEqual(decoded.age, 0.0)
    XCTAssertEqual(decoded.isStudent, false)  // Custom default
    XCTAssertEqual(decoded.isTeacher, true)   // Custom default
}
```

### String to Number Conversion

Automatic conversion from string to numeric types:

```swift
struct TestModel: Codable {
    let age: Int
    let age1: CGFloat
}

let jsonString = """
{
    "age": "10",
    "age1": "10.0"
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.age, 10)      // String "10" converted to Int
    XCTAssertEqual(decoded.age1, 10.0)   // String "10.0" converted to CGFloat
}
```

### Any Type Handling

Handle dynamic JSON structures with Any type:

```swift
@zcCodable
struct TestAnyModel: Codable {
    var age: Any
    @zcAnnotation(key: ["age1"], ignore: true)
    var age1: Float = 40
    var data: [String: Any]
    var arr: [Any]
}

let jsonString = """
{
    "age": "10",
    "age1": "10.0",
    "data": {
        "a": 1,
        "b": "2"
    },
    "arr": ["1", "2"]
}
"""

if let decoded = jsonData.asDecodable(TestAnyModel.self) {
    XCTAssertEqual(decoded.age as! String, "10")
    XCTAssertEqual(decoded.age1, 40.0)  // Ignored field with default value
    XCTAssertEqual(decoded.data["a"] as? Int, 1)
    XCTAssertEqual(decoded.data["b"] as? String, "2")
    XCTAssertEqual(decoded.arr as? [String], ["1", "2"])
}
```

### Field Ignoring

Ignore specific fields during parsing:

```swift
@zcCodable
struct TestAnyModel: Codable {
    @zcAnnotation(key: ["age1"], ignore: true)
    var age1: Float = 40
    var data: [String: Any]
}

let jsonString = """
{
    "age1": "10.0",
    "data": {
        "a": 1,
        "b": "2"
    }
}
"""

if let decoded = jsonData.asDecodable(TestAnyModel.self) {
    XCTAssertEqual(decoded.age1, 40.0)  // Ignored field keeps default value
    XCTAssertEqual(decoded.data["a"] as? Int, 1)
}
```

### Inheritance Support

Support for class inheritance in JSON parsing:

```swift
class BaseModel: Codable {
    var name: String
}

@zcInherit
class OneModel: BaseModel {
    var age: Int
}

let jsonString = """
{
    "name": "aa",
    "age": "10"
}
"""

if let decoded = jsonData.asDecodable(OneModel.self) {
    XCTAssertEqual(decoded.name, "aa")
    XCTAssertEqual(decoded.age, 10)
}
```

### Enum Handling

Handle enums with default cases:

```swift
enum Status: String, Codable, CaseDefaultsFirst {
    case active
    case inactive
    case pending
}

struct TestModel: Codable {
    var status: Status
}

let jsonString = """
{
    "status": "invalid"  // Will default to first case
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.status, .active)  // Defaults to first case
}
```
