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

/// Helper class required to remap property key recursively
class RecursiveMapper: NSObject {
    
    /// Remaps key of dictionary recursively.
    /// This functionality is required when updating keys also from sub objects.
    ///
    /// - parameter renaming: The dictionary holding the remapped keys.
    /// - parameter dictionary: The data representing the JSON (sub)object as a dictionary.
    func remap(renaming: [String: String], dictionary: inout [String: Any]) -> [String: Any] {
        for key in dictionary.keys {
            if var dict = dictionary[key] as? [String: Any], let renamingValue = renaming[key] {
                let value = remap(renaming: renaming, dictionary: &dict)
                dictionary.removeValue(forKey: key)
                dictionary[renamingValue] = value
            } else if let value = dictionary[key], let renamingValue = renaming[key] {
                dictionary.removeValue(forKey: key)
                dictionary[renamingValue] = value
            }
        }
        return dictionary
    }
    
}

