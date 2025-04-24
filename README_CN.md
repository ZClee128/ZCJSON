# ZCJSON

[![CI Status](https://img.shields.io/travis/18162711/ZCJSON.svg?style=flat)](https://travis-ci.org/18162711/ZCJSON)
[![Version](https://img.shields.io/cocoapods/v/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![License](https://img.shields.io/cocoapods/l/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)
[![Platform](https://img.shields.io/cocoapods/p/ZCJSON.svg?style=flat)](https://cocoapods.org/pods/ZCJSON)

ZCJSON 是一个强大的 Swift JSON 解析库，它扩展了 Codable 的功能，提供了默认值、类型转换和 Any 类型处理等特性。

## 特性

- 🎯 自动处理缺失字段的默认值
- 🔄 字符串到数字的自动转换
- 📦 Any 类型处理（字典和数组）
- 🚫 字段忽略注解
- 👥 继承支持
- 🎲 枚举默认值处理
- 🏗️ 宏支持代码生成

## 安装

### CocoaPods

ZCJSON 可以通过 [CocoaPods](https://cocoapods.org) 安装。在 Podfile 中添加以下行：

```ruby
pod 'ZCJSON'
```

### Swift Package Manager

ZCJSON 支持通过 Swift Package Manager 安装。在 Xcode 中：

1. 选择 File > Add Packages...
2. 在搜索框中输入：`https://github.com/ZClee128/ZCJSON.git`
3. 选择版本规则（推荐选择 Up to Next Major）
4. 点击 Add Package

或者直接在 Package.swift 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/ZClee128/ZCJSON.git", from: "1.0.0")
]
```

## 使用

### 基础 JSON 解析

```swift
// 字典转模型
let model = data.asDecodable(Model.self)

// 模型转 JSON 字符串
model.toJSONString()
```

### 默认值处理

ZCJSON 为 JSON 中缺失的字段提供默认值：

```swift
struct User: Codable {
    let name: String
    let age: Int  // 如果缺失则为 0
    @Default<Bool.False>
    var isActive: Bool  // 如果缺失则为 false
    @Default<Bool.True>
    var isVerified: Bool  // 如果缺失则为 true
}
```

### 字符串转数字

自动将字符串数字转换为数值类型：

```swift
struct Product: Codable {
    let id: Int        // "123" -> 123
    let price: CGFloat // "99.99" -> 99.99
}
```

### Any 类型处理

处理动态 JSON 结构：

```swift
@zcCodable
struct DynamicModel: Codable {
    var data: [String: Any]
    var items: [Any]
}
```

### 字段忽略

在解析时忽略特定字段：

```swift
struct User: Codable {
    @zcAnnotation(key: ["password"], ignore: true)
    var password: String = "default"
}
```

### 枚举处理

处理带默认值的枚举：

```swift
enum Status: String, Codable, CaseDefaultsFirst {
    case active
    case inactive
    case pending
}
```

### 继承支持

支持 JSON 解析中的类继承：

```swift
class BaseModel: Codable {
    var name: String
}

@zcInherit
class UserModel: BaseModel {
    var age: Int
}
```

## 高级示例

### 包含多个特性的复杂模型

```swift
@zcCodable
struct ComplexModel: Codable {
    // 默认值
    @Default<Bool.True>
    var isEnabled: Bool
    
    // 字符串转数字
    let count: Int
    
    // Any 类型处理
    var metadata: [String: Any]
    var items: [Any]
    
    // 带默认值的枚举
    var status: Status
    
    // 忽略字段
    @zcAnnotation(key: ["internal"], ignore: true)
    var internalData: String = "default"
}
```

## 单元测试示例

### 默认值处理

ZCJSON 自动处理缺失字段的默认值：

```swift
// 测试缺失字段的默认值
struct TestModel: Codable {
    let name: String
    let age: Int  // 如果缺失则为 0
}

let jsonString = """
{
    "name": "Alice"
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.name, "Alice")
    XCTAssertEqual(decoded.age, 0)  // 缺失字段的默认值
}
```

### 自定义默认值

使用 `@Default` 指定自定义默认值：

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
    XCTAssertEqual(decoded.isStudent, false)  // 自定义默认值
    XCTAssertEqual(decoded.isTeacher, true)   // 自定义默认值
}
```

### 字符串转数字

自动将字符串转换为数值类型：

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
    XCTAssertEqual(decoded.age, 10)      // 字符串 "10" 转换为 Int
    XCTAssertEqual(decoded.age1, 10.0)   // 字符串 "10.0" 转换为 CGFloat
}
```

### Any 类型处理

处理动态 JSON 结构：

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
    XCTAssertEqual(decoded.age1, 40.0)  // 忽略字段保持默认值
    XCTAssertEqual(decoded.data["a"] as? Int, 1)
    XCTAssertEqual(decoded.data["b"] as? String, "2")
    XCTAssertEqual(decoded.arr as? [String], ["1", "2"])
}
```

### 字段忽略

在解析时忽略特定字段：

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
    XCTAssertEqual(decoded.age1, 40.0)  // 忽略字段保持默认值
    XCTAssertEqual(decoded.data["a"] as? Int, 1)
}
```

### 继承支持

支持 JSON 解析中的类继承：

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

### 枚举处理

处理带默认值的枚举：

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
    "status": "invalid"  // 将默认使用第一个 case
}
"""

if let decoded = jsonData.asDecodable(TestModel.self) {
    XCTAssertEqual(decoded.status, .active)  // 默认使用第一个 case
}
```

### 整数值枚举

处理带有整数值的枚举：

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
    XCTAssertEqual(decoded.type, .one)  // 将整数值解析为枚举 case
}
```

## 作者

ZClee128, 876231865@qq.com

## 许可证

ZCJSON 使用 MIT 许可证。详见 LICENSE 文件。

## 支持

如果遇到解析问题或有任何疑问，请联系我或加入 QQ 群：982321096 
