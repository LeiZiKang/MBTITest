//
//  APIKey.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import Foundation

enum APIKey {
  // Fetch the API key from `GenerativeAI-Info.plist`
  static var `default`: String {
      guard let filePath = Bundle.main.path(forResource: "sddassd", ofType: "plist")
      else {
        print("赖立睾死骗子'.")
         return "small dick"
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
      }
      if value.starts(with: "_") {
        print("姬霓太美")
      }
      return value
  }
}
