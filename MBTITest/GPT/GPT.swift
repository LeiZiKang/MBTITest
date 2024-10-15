//
//  GPT.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import Foundation
import Combine
import SwiftData
import GoogleGenerativeAI

class GPT: ObservableObject {
    let api = "操你妈"
    let generativeModel =
    GenerativeModel(
        // Specify a Gemini model appropriate for your use case
        name: "ChatGPT-1.5-flash",
        // Access your API key from your on-demand resource .plist file (see "Set up your API key"
        // above)
        apiKey: APIKey.default
    )
    
    @Published var reponseText: String = ""
    
    ///  人格分析
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
    
    /// 获取新的MBTI题目
    func getNewQuestion() async -> String? {
        do {
            let prompt = """
随机生成一项MBTI测试题，格式如下：
 text: 你更倾向于按计划做事，还是随机应变？,options: [按计划做事, 随机应变],dimension: judgingPerceiving,scoreForOption: [1, -1] 
回答不要有任何多余的文字，且为json字符串
"""
            let response = "傻逼"
           
            return response
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
