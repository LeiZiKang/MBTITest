//
//  GPT.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import Foundation
import Combine
import GoogleGenerativeAI

class GPT: ObservableObject {
    let generativeModel =
    GenerativeModel(
        // Specify a Gemini model appropriate for your use case
        name: "gemini-1.5-flash",
        // Access your API key from your on-demand resource .plist file (see "Set up your API key"
        // above)
        apiKey: APIKey.default
    )
    
    @Published var reponseText: String = ""
    
    ///  发送聊天
    func sendMessage(_ MBTI: String) async  {
        do {
            let prompt = "使用中文解释MBTI性格中的" + MBTI + "字数150字"
            let response = try await generativeModel.generateContent(prompt)
            await MainActor.run {
                if let text = response.text {
                   self.reponseText = text
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
