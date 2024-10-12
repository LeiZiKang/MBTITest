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
    let options: [String]
    let dimension: Dimension
    let scoreForOption: [Double] // 每个选项对应的得分
    let id: String
    init(text: String, options: [String], dimension: Dimension, scoreForOption: [Double]) {
        self.text = text
        self.options = options
        self.dimension = dimension
        self.scoreForOption = scoreForOption
        self.id = UUID().uuidString
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
        let typeComponents = scores.map { dimension, score in
            switch dimension {
            case .extraversionIntroversion:
                score > 0 ? "E" : "I"
            case .judgingPerceiving :
                score > 0 ? "J" : "P"
            case .sensingIntuition:
                score > 0 ? "S" : "I"
            case .thinkingFeeling:
                score > 0 ? "T" : "F"
            }
        }
        return typeComponents.joined()
    }
}


