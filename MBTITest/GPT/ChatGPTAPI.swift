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
    private var historyList: [Message] = []
    
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
    
    

    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(
            model: model,
            temperature: temperature,
            messages: generateMessages(from: text),
            stream: stream
        )
        return try JSONEncoder().encode(request)
    }

    /// 產生請求訊息陣列
    private func generateMessages(from text: String) -> [Message] {
        // 系統訊息+歷史訊息+新的提問訊息
        var messages = [systemMessage] + historyList + [Message(role: .user, content: text)]

        // 確認內容總字數是否大於最大tokens數量
        if messages.contentCount > (4000 * 4) {
            _ = historyList.dropFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }

    private func appendToHistoryList(userText: String, responseText: String) {
        historyList.append(.init(role: .user, content: userText))
        historyList.append(.init(role: .assistant, content: responseText))
    }
    
    // 發出提問請求(以串流方式回應)
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }

        guard 200...299 ~= httpResponse.statusCode else {
            var errorMessage = "Bad Response: \(httpResponse.statusCode)"
            var error = ""
            for try await line in result.lines {
                error.append(line)
            }
            if let errorData = error.data(using: .utf8), let errorReponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: errorData).error {
                errorMessage.append(",\n\(errorReponse.message)")
            }
            throw errorMessage
        }

        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self = self else { return }
                do {
                    var streamText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                           let content = response.choices.first?.delta.content {
                            streamText += content
                            continuation.yield(content)
                        }
                    }
                    self.appendToHistoryList(userText: text, responseText: streamText)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // 發出提問請求(以完整訊息回應)
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }

        guard 200...299 ~= httpResponse.statusCode else {
            var error = "Bad Response: \(httpResponse.statusCode)"
            if let errorResposne = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                error.append(",\n \(errorResposne.message)")
            }
            throw error
        }

        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.message.content ?? ""
            self.appendToHistoryList(userText: text, responseText: responseText)
            return responseText
        } catch {
            throw error
        }
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

// MARK: - Resposne
struct CompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: Message
}

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct StreamChoice: Decodable {
    let delta: StreamMessage
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}

// MARK: - Error
struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}
struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}
