//
//  Dictionary.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

extension Dictionary {
    func convertToData() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return data
        } catch {
            print("Error while converting dict to Data \(error)")
            return nil
        }
    }
    
    func merge<K, V>(dict1: [K: V], dict2: [K: V]) -> [K: V] {
        var merged = dict1
        dict2.forEach { key, value in
            merged[key] = value
        }
        return merged
    }
}
