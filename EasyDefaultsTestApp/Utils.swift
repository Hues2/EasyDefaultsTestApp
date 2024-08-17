//
//  Utils.swift
//  EasyDefaultsTestApp
//
//  Created by Greg Ross on 17/08/2024.
//

import Foundation

class Utils {
    /// Decodes `Data` into a dictionary
    static func decodeDataToDictionary(_ data : Data) -> [String: Any] {
        if let decodedDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return decodedDict
        } else {
            // If decoding fails, set an empty dictionary
            return [:]
        }
    }
}
