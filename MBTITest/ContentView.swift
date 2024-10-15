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
    // 动画的启动状态
      @State var anim = true
      // 摆动的幅度
      @State var range = 5.0
    var message: AttributedString {
        let string = "赖立睾是个大傻逼"
        var result = AttributedString()

        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            // 利用一丢丢数学知识来计算文字上下偏移的位置
            letterString.baselineOffset = sin(Double(index)) * range * (anim ? -1 : 1)
            result += letterString
        }

        result.font = anim ? .largeTitle.weight(.black) : .largeTitle
        result.foregroundColor = anim ? .red : .orange

        return result
    }

    var body: some View {
            
        VStack(spacing: 50) {
            
            Spacer()
            
            Text(message)
            
            
            Spacer()
            
        }
        .onAppear {
            withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                anim.toggle()
            }
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
        var newIndex = 0
        if currentIndex == questions.count - 1 {
            newIndex = 0
        } else {
            newIndex = currentIndex + 1
        }
        changeBanner(newIndex: newIndex)
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



