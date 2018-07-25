/// Created by Matteo Sassano on 24.07.18
/// Copyright (c) 2018 Matteo Sassano
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

/// Defines the object mapper which is able to map JSON data to an instance of a given type.
/// The passed generic type has to implement the protocol Codable.
public class ObjectMapper<T: Codable>: NSObject {
    
    /// Decodes an object from JSON data.
    ///
    /// If the passed data `data` does not correspond to an JSON object
    /// or to the ObjectMapper type, this function returns nil
    ///
    /// - parameter data: The data representing the JSON object.
    public func map(data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    /// Decodes an object from JSON data & allows to remap the JSON keys to custom keys.
    /// E.g. if the JSON object holds a key named `blo_key` but the instance property is named `blo`,
    /// the key can be remapped by putting a map blo_key -> blo in the dictionary `renaming`:
    ///
    ///     var renaming = [String: String]()
    ///     r["blo_key"] = "blo"
    ///     let object = ObjectMapper<Bla>().map(data: data, renaming: renaming)
    ///
    /// If the passed dictionary `renaming` is empty, no remap is performed.
    /// In this case it is adviced to utilize map(data:).
    ///
    /// If the passed data `data` does not correspond to an JSON object
    /// or to the ObjectMapper type, this function returns nil
    ///
    /// - parameter data: The data representing the JSON object.
    /// - parameter renaming: The dictionary holding the remapped keys.
    public func map(data: Data, renaming: [String: String]) -> T? {
        do {
            var jsonData: Data? = nil
            if var jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                for key in renaming.keys {
                    if let value = jsonObject[key], let renamingValue = renaming[key] {
                        jsonObject.removeValue(forKey: key)
                        jsonObject[renamingValue] = value
                    }
                }
                jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            }
            if let data = jsonData {
                return map(data: data)
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    /// Decodes an object from JSON data & allows to remap the JSON keys to custom keys.
    /// E.g. if the JSON object holds a key named `blo_key` but the instance property is named `blo`,
    /// the key can be remapped by putting a map blo_key -> blo in the dictionary `renaming`:
    ///
    ///     var renaming = [String: String]()
    ///     r["blo_key"] = "blo"
    ///     let object = ObjectMapper<Bla>().map(data: data, renaming: renaming, recursive: true)
    ///
    /// If the passed dictionary `renaming` is empty, no remap is performed.
    /// In this case it is adviced to utilize map(data:).
    ///
    /// If the passed data `data` does not correspond to an JSON object
    /// or to the ObjectMapper type, this function returns nil
    ///
    /// - parameter data: The data representing the JSON object.
    /// - parameter renaming: The dictionary holding the remapped keys.
    /// - parameter recursive: Bool value which defines wheather also sub attributes should be remapped.
    public func map(data: Data, renaming: [String: String], recursive: Bool) -> T? {
        if recursive == false {
            return map(data: data, renaming: renaming)
        } else {
            do {
                var jsonData: Data? = nil
                if var jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    jsonObject = RecursiveMapper().remap(renaming: renaming, dictionary: &jsonObject)
                    jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                }
                if let data = jsonData {
                    return map(data: data)
                }
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
}
