//
//  ContentView.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import SwiftUI
import ZKCompoments


struct ContentView: View {
    private let questions: [Question] = MBTIQuestions

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



