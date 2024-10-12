//
//  Model.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import Foundation

/// MBTI
/// 理解 MBTI 评分体系
/// MBTI 评分体系的基本原理。MBTI 将人格分为四个维度：

/// 外向（E） vs. 内向（I）： 能量来源
/// 感觉（S） vs. 直觉（N）： 获取信息的方式
/// 思考（T） vs. 情感（F）： 做决定的方式
/// 判断（J） vs. 感知（P）： 生活方式
/// 每个维度都有两个极端，通过对一系列问题的回答，我们可以计算出个体在每个维度上的偏好，从而确定其 MBTI 类型。

struct Question :Identifiable{
    let text: String
    var options: [Option]
    let dimension: Dimension
    let scoreForOption: [Double] // 每个选项对应的得分
    let id: String
    init(text: String, options: [String], dimension: Dimension, scoreForOption: [Double]) {
        self.text = text
        self.options = options.map({ str in
            Option(name: str)
        })
        self.dimension = dimension
        self.scoreForOption = scoreForOption
        self.id = UUID().uuidString
    }
    
    mutating func selectOption(_ option: Option) {
      
        if let index =  self.options.firstIndex( where: { opt in
            opt.id == option.id
       }) {
            self.options[index].isSelected.toggle()
       }
    }
}

struct Option: Identifiable {
    var name: String
    var isSelected: Bool
    var id: String
    init(name: String) {
        self.name = name
        self.isSelected = false
        self.id = UUID().uuidString
    }
    
    mutating func click() {
        self.isSelected.toggle()
    }
}
/// 维度
enum Dimension: String {
    case extraversionIntroversion = "ExtraversionIntroversion"
    case sensingIntuition = "SensingIntuition"
    case thinkingFeeling = "ThinkingFeeling"
    case judgingPerceiving = "JudgingPerceiving"
}

struct Answer {
    let questionID: String
    let selectedOptionIndex: Int
}

struct MBTIResult {
    let type: String
    let scores: [Dimension: Double]
}

class MBTICalculator {
    
    func calculate(answers: [Answer], questionBank: [Question]) -> MBTIResult {
        var scores: [Dimension: Double] = [.extraversionIntroversion: 0, .sensingIntuition: 0, .thinkingFeeling: 0, .judgingPerceiving: 0]
        
        for answer in answers {
            if  let question = questionBank.first(where: { question in
                question.id == answer.questionID
            }) {
                let selectedOptionIndex = answer.selectedOptionIndex
                let score = question.scoreForOption[selectedOptionIndex]
                scores[question.dimension]! += score
            }
        }
        
        // 简化版类型判断，实际应用中可以采用更复杂的算法
        let type = determineMBTIType(scores)
        
        return MBTIResult(type: type, scores: scores)
    }
    
    private func determineMBTIType(_ scores: [Dimension: Double]) -> String {
        var type = Array(repeating: "", count: 4)
        scores.forEach{ dimension, score in
            switch dimension {
            case .extraversionIntroversion:
                type.insert(score > 0 ? "E" : "I", at: 0)
            case .sensingIntuition:
                type.insert(score > 0 ? "S" : "N", at: 1)
            case .thinkingFeeling:
                type.insert(score > 0 ? "T" : "F", at: 2)
            case .judgingPerceiving :
                type.insert(score > 0 ? "J" : "P", at: 3)
            }
        }
        return type.joined()
    }
}

// MARK: 题目

let MBTIQuestions = [
    Question(text: "你更喜欢独处还是社交？", options: ["独处", "社交"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢计划好一切还是随性而为？", options: ["计划好", "随性"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更关注事实还是可能性？", options: ["事实", "可能性"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
    Question(text: "你更喜欢用逻辑分析还是情感判断？", options: ["逻辑分析", "情感判断"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
    Question(text: "你更喜欢大局观还是细节？", options: ["大局观", "细节"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢按部就班还是随机应变？", options: ["按部就班", "随机应变"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢表达自己的想法还是倾听别人的意见？", options: ["表达", "倾听"], dimension: .extraversionIntroversion, scoreForOption: [1, -1]),
    Question(text: "你更喜欢具体的事实还是抽象的概念？", options: ["具体事实", "抽象概念"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
    Question(text: "你更看重效率还是和谐？", options: ["效率", "和谐"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
    Question(text: "你更喜欢开放式的结局还是明确的答案？", options: ["开放式", "明确答案"], dimension: .judgingPerceiving, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢独自工作还是团队合作？", options: ["独自工作", "团队合作"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢按照计划行事还是灵活调整？", options: ["按照计划", "灵活调整"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢新颖的事物还是熟悉的事物？", options: ["新颖事物", "熟悉事物"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
    Question(text: "你更看重逻辑一致性还是人情世故？", options: ["逻辑一致性", "人情世故"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
    Question(text: "你更喜欢提前规划还是临场发挥？", options: ["提前规划", "临场发挥"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢参与大型聚会还是小范围的交流？", options: ["大型聚会", "小范围交流"], dimension: .extraversionIntroversion, scoreForOption: [1, -1]),
    Question(text: "你更喜欢关注细节还是整体？", options: ["细节", "整体"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
    Question(text: "你更喜欢客观的事实还是主观感受？", options: ["客观事实", "主观感受"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
    Question(text: "你更喜欢有条理的生活还是随意的生活？", options: ["有条理", "随意"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢理论知识还是实际应用？", options: ["理论知识", "实际应用"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
    Question(text: "在团队项目中，你更倾向于提出新想法，还是负责将想法落地？", options: ["提出新想法", "负责落地"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
    Question(text: "参加聚会时，你更喜欢和熟悉的朋友聊天，还是结交新朋友？", options: ["熟悉的朋友", "新朋友"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
    Question(text: "面对一个新问题，你更喜欢先收集大量信息，还是直接开始行动？", options: ["收集信息", "直接行动"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
    Question(text: "做决定时，你更看重个人价值观，还是客观事实？", options: ["个人价值观", "客观事实"], dimension: .thinkingFeeling, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢有明确截止日期的任务，还是开放式的任务？", options: ["明确截止日期", "开放式任务"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "在面对冲突时，你更倾向于调解，还是坚持自己的立场？", options: ["调解", "坚持立场"], dimension: .thinkingFeeling, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢按计划行事，还是喜欢临时改变计划？", options: ["按计划", "临时改变"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢在安静的环境中工作，还是在热闹的环境中工作？", options: ["安静环境", "热闹环境"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢抽象的概念，还是具体的事物？", options: ["抽象概念", "具体事物"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢关注细节，还是关注整体？", options: ["细节", "整体"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
    Question(text: "你更喜欢按照步骤做事，还是喜欢跳跃思维？", options: ["按照步骤", "跳跃思维"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "面对一个新的挑战，你更倾向于寻求别人的建议，还是自己尝试解决？", options: ["寻求建议", "自己尝试"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
    Question(text: "你更喜欢参加有明确目标的活动，还是喜欢开放性的活动？", options: ["明确目标", "开放性"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
    Question(text: "你更喜欢理论知识，还是实际操作？", options: ["理论知识", "实际操作"], dimension: .sensingIntuition, scoreForOption: [-1, 1])
]
