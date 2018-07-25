# ObjectMapper
ObjectMapper is a JSON data to instance mapping library written in swift.

## Installation
### Manual installation
Download the package and import the framework into your project.

## Usage
### Import module

```swift
import ObjectMapper
```

### Map JSON data to instance
The class type of the mapped object must implement Codable.

```swift
let object = ObjectMapper<TestClass>().map(data: data)

class TestClass: Codable {
   var a: Int = 0
}
```

### Map JSON data to instance with custom JSON keys
The key conversion must be stored in a dictionary. The conversion is needed when the JSON has to be mapped to an object wich does not refer to the actual JSON object.
E.g. if the response looks like the JSON below, we need to rename the key.

```json
{
   "a_key": 10
}
```

```swift
var renaming = [String: String]()
renaming["a_key"] = "a"
let object = ObjectMapper<TestClass>().map(data: data, renaming: renaming)

class TestClass: Codable {
  var a: Int = 0
}
```

or

```swift
let object = ObjectMapper<TestClass>().map(data: data, renaming: ["a_key": "a"])

class TestClass: Codable {
  var a: Int = 0
}
```
