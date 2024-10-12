//
//  ContentView.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import SwiftUI
import ZKCompoments

struct ContentView: View {
    private let questions: [Question] = [
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

    @State private var answers: [Answer] = []
    @State private var result: MBTIResult?
    @State var offset: CGFloat = .zero
    @State public var currentIndex: Int = 0
    @State private var showResultView: Bool = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("\(answers.count) / \(questions.count)")
                
                HStack {
                    ForEach(presentViews()) { question in
                        ZStack {
                            Color.green
                            VStack {
                                Text(question.text)
                                    .font(.title)
                                
                                HStack{
                                    ForEach(question.options, id: \.self) { option in
                                        Button(option) {
                                            let answer = Answer(questionID: question.id, selectedOptionIndex: question.options.firstIndex(of: option)!)
                                            if !self.answers.contains(where: { ans in
                                                ans.questionID == answer.questionID
                                            }){
                                                self.answers.append(answer)
                                            }
                                            scrollNext()
                                        }
                                        .controlSize(.large)
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.roundedRectangle)
                                        .padding()
                                    }
                                }
                            }
                        }
                        .frame(width: screenW - 40)
                        .frame(maxHeight: .infinity)
                        .cornerRadius(20)
                    }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offset = value.translation.width
                        })
                        .onEnded({ value in
                            var newIndex = 0
                            // 向右拖动，显示上一张
                            if value.translation.width > 50 {
                                if currentIndex == 0 {
                                    newIndex = questions.count - 1
                                } else {
                                    newIndex = currentIndex - 1
                                }
                            }
                            // 向左拖动，显示下一张
                            if value.translation.width < 50 {
                                if currentIndex == questions.count - 1 {
                                    newIndex = 0
                                } else {
                                    newIndex = currentIndex + 1
                                }
                            }
                            
                            changeBanner(newIndex: newIndex)
                        })
                )
                .onChange(of: self.answers.count) { _, _ in
                    if self.answers.count == self.questions.count {
                        self.showResultView = true
                    }
                }
                .sheet(isPresented: $showResultView) {
                    
                } content: {
                    let result = MBTICalculator().calculate(answers: self.answers, questionBank: self.questions)
                    ResultView(result: result)
                }


            }
 
            .navigationBarTitle("MBTI 测试")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // 前台展示的3张图片
    func presentViews() -> [Question] {
        let current = questions[currentIndex]
        let pre = currentIndex == 0 ? questions.last! : questions[currentIndex - 1]
        let next = currentIndex == questions.count - 1 ? questions.first! : questions[currentIndex + 1]
        return [pre, current, next]
    }
    // 轮播动画
    func changeBanner(newIndex: Int) {
        withAnimation(.linear(duration: 0.5)) {
            currentIndex = newIndex
            offset = .zero
        }
    }
    // 下一页
    func scrollNext() {
        var newIndex = 0
        if currentIndex == questions.count - 1 {
            newIndex = 0
        } else {
            newIndex = currentIndex + 1
        }
        changeBanner(newIndex: newIndex)
    }
}


// ResultView 视图用于展示测试结果
struct ResultView: View {
    let result: MBTIResult

    var body: some View {
        Text("你的 MBTI 类型是：\(result.type)")
        // ... 其他结果展示
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}

// MARK: - 题目

//let questions: [Question] = [
//    Question(text: "你更喜欢独处还是社交？", options: ["独处", "社交"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢计划好一切还是随性而为？", options: ["计划好", "随性"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更关注事实还是可能性？", options: ["事实", "可能性"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢用逻辑分析还是情感判断？", options: ["逻辑分析", "情感判断"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢大局观还是细节？", options: ["大局观", "细节"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢按部就班还是随机应变？", options: ["按部就班", "随机应变"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢表达自己的想法还是倾听别人的意见？", options: ["表达", "倾听"], dimension: .extraversionIntroversion, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢具体的事实还是抽象的概念？", options: ["具体事实", "抽象概念"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
//    Question(text: "你更看重效率还是和谐？", options: ["效率", "和谐"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢开放式的结局还是明确的答案？", options: ["开放式", "明确答案"], dimension: .judgingPerceiving, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢独自工作还是团队合作？", options: ["独自工作", "团队合作"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢按照计划行事还是灵活调整？", options: ["按照计划", "灵活调整"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢新颖的事物还是熟悉的事物？", options: ["新颖事物", "熟悉事物"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
//    Question(text: "你更看重逻辑一致性还是人情世故？", options: ["逻辑一致性", "人情世故"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢提前规划还是临场发挥？", options: ["提前规划", "临场发挥"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢参与大型聚会还是小范围的交流？", options: ["大型聚会", "小范围交流"], dimension: .extraversionIntroversion, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢关注细节还是整体？", options: ["细节", "整体"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢客观的事实还是主观感受？", options: ["客观事实", "主观感受"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢有条理的生活还是随意的生活？", options: ["有条理", "随意"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢理论知识还是实际应用？", options: ["理论知识", "实际应用"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
//    Question(text: "在团队项目中，你更倾向于提出新想法，还是负责将想法落地？", options: ["提出新想法", "负责落地"], dimension: .thinkingFeeling, scoreForOption: [1, -1]),
//    Question(text: "参加聚会时，你更喜欢和熟悉的朋友聊天，还是结交新朋友？", options: ["熟悉的朋友", "新朋友"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
//    Question(text: "面对一个新问题，你更喜欢先收集大量信息，还是直接开始行动？", options: ["收集信息", "直接行动"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
//    Question(text: "做决定时，你更看重个人价值观，还是客观事实？", options: ["个人价值观", "客观事实"], dimension: .thinkingFeeling, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢有明确截止日期的任务，还是开放式的任务？", options: ["明确截止日期", "开放式任务"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "在面对冲突时，你更倾向于调解，还是坚持自己的立场？", options: ["调解", "坚持立场"], dimension: .thinkingFeeling, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢按计划行事，还是喜欢临时改变计划？", options: ["按计划", "临时改变"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢在安静的环境中工作，还是在热闹的环境中工作？", options: ["安静环境", "热闹环境"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢抽象的概念，还是具体的事物？", options: ["抽象概念", "具体事物"], dimension: .sensingIntuition, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢关注细节，还是关注整体？", options: ["细节", "整体"], dimension: .sensingIntuition, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢按照步骤做事，还是喜欢跳跃思维？", options: ["按照步骤", "跳跃思维"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "面对一个新的挑战，你更倾向于寻求别人的建议，还是自己尝试解决？", options: ["寻求建议", "自己尝试"], dimension: .extraversionIntroversion, scoreForOption: [-1, 1]),
//    Question(text: "你更喜欢参加有明确目标的活动，还是喜欢开放性的活动？", options: ["明确目标", "开放性"], dimension: .judgingPerceiving, scoreForOption: [1, -1]),
//    Question(text: "你更喜欢理论知识，还是实际操作？", options: ["理论知识", "实际操作"], dimension: .sensingIntuition, scoreForOption: [-1, 1])
//]


