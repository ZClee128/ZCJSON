import XCTest
import ZCJSON
import ZCMacro

class BaseModel: Codable {
    var name: String
}

@zcInherit
class OneModel: BaseModel {
    var age: Int
}

@zcCodable
struct TestAnyModel: Codable {
    var age: Any
    @zcAnnotation(key: ["age1"], ignore: true)
    var age1: Float = 40
    var data: [String: Any]
    var arr: [Any]
}

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: 测试后端字段不存在, 基础类型可以不需要写默认值，因为底层处理了，如果有其他基础类型没有覆盖可以自己遵循协议扩展
    func testIntJSONParsing() {
        struct TestModel: Codable {
            let name: String
            let age: Int
        }

        let jsonString = """
        {
            "name": "Alice"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestModel.self) {
                XCTAssertEqual(decoded.name, "Alice")
                XCTAssertEqual(decoded.age, 0)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试其他基础类型后台没有返回字段，可是又不是可选值，需要给默认值
    func testOtherJSONParsing() {
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

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestModel.self) {
                XCTAssertEqual(decoded.name, "Alice")
                XCTAssertEqual(decoded.age, 0.0)
                XCTAssertEqual(decoded.isStudent, false)
                XCTAssertEqual(decoded.isTeacher, true)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    // MARK: 测试使用Int，float，CGFloat等来解析后台返回是字符串类型
    func testStringToNumber() {
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

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestModel.self) {
                XCTAssertEqual(decoded.age, 10)
                XCTAssertEqual(decoded.age1, 10.0)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试Any解析
    func testAnyCodable() {

        let jsonString = """
        {
            "age": "10",
            "age1": "10.0"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestAnyModel.self) {
                XCTAssertEqual(decoded.age as! String, "10")
                XCTAssertEqual(decoded.age1, 10.0)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试字典any解析
    func testAnyDicCodable() {

        let jsonString = """
        {
            "data": {
        "a": 1,
        "b": "2",
        },
            "age1": "10.0"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestAnyModel.self) {
                XCTAssertEqual(decoded.age is Void, true)
                XCTAssertEqual(decoded.age1, 10.0)
                let data = decoded.data
                XCTAssertEqual(data["a"] as? Int, 1)
                XCTAssertEqual(data["b"] as? String, "2")
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试数组any解析
    func testAnyArrCodable() {

        let jsonString = """
        {
            "data": {
        "a": 1,
        "b": "2",
        },
            "age1": "10.0",
        "arr": ["1","2"]
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestAnyModel.self) {
                XCTAssertEqual(decoded.age is Void, true)
                XCTAssertEqual(decoded.age1, 10.0)
                let data = decoded.data
                XCTAssertEqual(data["a"] as? Int, 1)
                XCTAssertEqual(data["b"] as? String, "2")
                XCTAssertEqual(decoded.arr as? [String], ["1", "2"])
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试过滤不需要解析字段
    func testIgnoreCodable() {

        let jsonString = """
        {
            "data": {
        "a": 1,
        "b": "2",
        },
            "age1": "10.0",
        "arr": ["1","2"]
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestAnyModel.self) {
                XCTAssertEqual(decoded.age is Void, true)
                XCTAssertEqual(decoded.age1, 40.0)
                let data = decoded.data
                XCTAssertEqual(data["a"] as? Int, 1)
                XCTAssertEqual(data["b"] as? String, "2")
                XCTAssertEqual(decoded.arr as? [String], ["1", "2"])
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试继承解析
    func testInheritCodable() {

        let jsonString = """
        {
            "name": "aa",
            "age": "10"
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(OneModel.self) {
                XCTAssertEqual(decoded.name, "aa")
                XCTAssertEqual(decoded.age, 10)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
    
    /// 测试枚举测试解析
    func testEnumCodable() {

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
            "age": "10"
        "type: 1
        }
        """

        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("JSON 字符串无法转换为 Data")
            return
        }

        do {
            if let decoded = jsonData.asDecodable(TestModel.self) {
                XCTAssertEqual(decoded.name, "aa")
                XCTAssertEqual(decoded.age, 10)
                XCTAssertEqual(decoded.type, .one)
            }
        } catch {
            XCTFail("解析失败: \(error)")
        }
    }
}
