//
//  ContentView.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import SwiftUI
import SwiftData
import ZKCompoments
import GoogleGenerativeAI
import SwiftyJSON

struct ContentView: View {
    
    @Query private var questions: [Question]
    @Environment(\.modelContext) var context
    @State private var answers: [Answer] = []
    @State private var progress: Double = 0
    @State private var result: MBTIResult?
    @State var offset: CGFloat = .zero
    @State public var currentIndex: Int = 0
    @State private var showResultView: Bool = false
    @ObservedObject var gpt = GPT()
    var body: some View {
        NavigationView {
            
            VStack {
                
                // 进度条
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical,5)
                
                // swipe card
                HStack {
                    ForEach(presentViews()) { question in
                        ZStack {
                            Color.cyan.opacity(0.6)
                            VStack {
                                Text(question.text)
                                    .font(.title)
                                    .padding()
                                
                                HStack{
                                    ForEach(question.options, id: \.self) { option in
                                        Button{
                                            let answer = Answer(questionID: question.id, selectedOptionIndex: question.options.firstIndex(of: option)!)
                                            if !self.answers.contains(where: { ans in
                                                ans.questionID == answer.questionID
                                            }){
                                                self.answers.append(answer)
                                            } else {
                                                if let path = self.answers.firstIndex(where: { ans in
                                                    ans.questionID == question.id
                                                }) {
                                                    self.answers[path] = answer
                                                }
                                            }
                                            
                                            scrollNext()
                                            
                                            
                                        } label: {
                                            Text(option)
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(width: 100)
                                                .background(Color.gray.opacity(0.4))
                                                .cornerRadius(16)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                
                                
                                Text("Answer:")
                                    .font(.title2)
                                    .padding()
                                
                                if let ans = answers[safe: currentIndex] {
                                    Text(question.options[ans.selectedOptionIndex])
                                        .foregroundStyle(Color.red)
                                        .padding()
                                } else {
                                    Text("")
                                        .padding()
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
                        self.result = MBTICalculator().calculate(answers: self.answers, questionBank: self.questions)
                        Task {
                            if let result = self.result {
                                await self.gpt.sendMessage(result.type)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showResultView) {
                    clearAllData()
                } content: {
                    if let result = self.result {
                        NavigationView {
                            ResultView(result: result)
                                .environmentObject(gpt)
                                .toolbar {
                                    ToolbarItem {
                                        Button {
                                            self.showResultView = false
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                        }
                                    }
                                }
                        }
                    }
                    
                }
                
                // 页码
                Text("\(currentIndex + 1) / \(questions.count)")
                    .animation(.bouncy)
                    .padding()
                
                
            }
            .onAppear(perform: {
                Task {
                    if let questionText = await gpt.getNewQuestion() {
                        let json = JSON(parseJSON: questionText)
                        let question = Question(json: json)
                        if !self.questions.contains(where: { que in
                            que.text == question.text
                        }) {
                            await MainActor.run {
                                self.context.insert(question)
                               try? self.context.save()
                            }
                        }
                    }
                }
                
            })
            
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
        withAnimation(.easeInOut) {
            currentIndex = newIndex
            offset = .zero
        }
    }
    
    // 下一页
    func scrollNext() {
        //        var newIndex = 0
        //        if currentIndex == questions.count - 1 {
        //            newIndex = 0
        //        } else {
        //            newIndex = currentIndex + 1
        //        }
        //        changeBanner(newIndex: newIndex)
    }
    
    // 还原全部数据
    func clearAllData() {
        withAnimation(.linear(duration: 0.5)) {
            self.answers.removeAll()
            self.currentIndex = 0
            self.result = nil
        }
    }
}


// ResultView 视图用于展示测试结果
struct ResultView: View {
    let result: MBTIResult
    @EnvironmentObject var gpt: GPT
    var body: some View {
        VStack {
            Text("\(result.type)")
                .font(.title)
            
            if gpt.reponseText.isEmpty {
                ProgressView("loading")
                    .progressViewStyle(.circular)
                    .padding()
            } else {
                Text(gpt.reponseText)
                    .padding()
            }
            
            
        }
    }
    
}

#Preview {
    NavigationView {
        ContentView()
    }
}



