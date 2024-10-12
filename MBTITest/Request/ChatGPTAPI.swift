//
//  MBHttpProperties.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import Foundation

//let MBTI = "https://api.aimlapi.com"
//
//let apikey = "82684a09338540b98269783571e2a483"

class ChatGPTAPI {
    
    private let apiKey: String
    private let model: String
    private let systemMessage: Message
    private let temperature: Double
    
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.aimlapi.com")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        return urlRequest
    }
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }
    private let jsonDecoder = JSONDecoder()

    
    init(
        apiKey: String,
        model: String = "gpt-3.5-turbo",
        systemPrompt: String = "You are a helpful assistant",
        temperature: Double = 1
    ) {
        self.apiKey = apiKey
        self.model = model
        self.systemMessage = .init(role: .system, content: systemPrompt)
        self.temperature = temperature
    }
    
    func test() {
        var urlRequest = self.urlRequest
        
    }
    
}

struct Request: Codable {
    /// 官方api model名稱
    let model: String
    ///
    let messages: [Message]
    /// 決定回答的隨機程度，越高越隨機
    let temperature: Double
    /// 資料是否以串流的方式回傳。false的話會等整段對話產生完才回傳，true的話會以token(大概為一個字/詞)的方式回傳，等等下面會有回傳資料的範例，也因為資料格式不同所以會根據此參數實作兩種請求的方法
    let stream: Bool
}

struct Message: Codable {
    let role: ChatGPTRole
    let content: String
    
    enum ChatGPTRole: String, Codable {
        case system
        case user
        case assistant
    }
}

extension Array where Element == Message {
    // 计算所有信息内容的总字数
    var contentCount: Int { reduce(0, { $0 + $1.content.count }) }
}
