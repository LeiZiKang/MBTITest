//
//  ContentView.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import SwiftUI
import ZKCompoments


struct ContentView: View {
    @State private var questions: [Question] = MBTIQuestions
    @State private var answers: [Answer] = []
    @State private var progress: Double = 0
    @State private var result: MBTIResult?
    @State var offset: CGFloat = .zero
    @State public var currentIndex: Int = 0
    @State private var showResultView: Bool = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                //                Text("\(answers.count) / \(questions.count)")
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                    .padding(.horizontal, 20)
                
                HStack {
                    ForEach(presentViews()) { question in
                        ZStack {
                            Color.cyan.opacity(0.6)
                            VStack {
                                Text(question.text)
                                    .font(.title)
                                
                                HStack{
                                    ForEach(question.options) { option in
                                        Button {
                                            let answer = Answer(questionID: question.id, selectedOptionIndex: question.options.firstIndex(where: { opt in
                                                opt.id == option.id
                                            })!)
                                            if !self.answers.contains(where: { ans in
                                                ans.questionID == answer.questionID
                                            }){
                                                self.answers.append(answer)
                                            }
                                            
                                            scrollNext()
                                            
                                            self.questions.enumerated().forEach { index, ques in
                                                guard ques.id == question.id else { return }
                                                questions[index].selectOption(option)
                                            }
                                        } label: {
                                            Text(option.name)
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(width: 100)
                                                .background( option.isSelected ? Color.green : Color.gray.opacity(0.4))
                                                .cornerRadius(16)
                                        }
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
                    self.progress = Double(self.answers.count) / Double(self.questions.count)
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



