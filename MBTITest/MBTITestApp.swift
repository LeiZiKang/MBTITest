//
//  MBTITestApp.swift
//  MBTITest
//
//  Created by 雷子康 on 2024/10/12.
//

import SwiftUI
import SwiftData
import GoogleGenerativeAI

@main
struct MBTITestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var container: ModelContainer
    
    init() {
        do {
            let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
            let config = ModelConfiguration(url: storeURL)
            container = try ModelContainer(for: Question.self, configurations: config)
        } catch {
            fatalError("Failed")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Question.self) { result in
            do {
                let container = try result.get()

                // 先检查有没数据
                let descriptor = FetchDescriptor<Question>()
                let existingQuestions = try container.mainContext.fetchCount(descriptor)
                guard existingQuestions == 0 else { return }

                let questions = MBTIQuestions
                // 导入数据
                for question in questions {
                    container.mainContext.insert(question)
                }
              
            } catch {
                print("Failed")
            }
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        Task {
//            await testResponse()
//        }
        
        
        return true
    }
    
    
}

extension AppDelegate {
    
    func testResponse() async {
        //        let generativeModel =
        //          GenerativeModel(
        //            // Specify a Gemini model appropriate for your use case
        //            name: "gemini-1.5-flash",
        //            // Access your API key from your on-demand resource .plist file (see "Set up your API key"
        //            // above)
        //            apiKey: APIKey.default
        //          )
        //
        //        let prompt = "Write a story about a magic backpack."
        //        do {
        //            let response = try await generativeModel.generateContent(prompt)
        //            if let text = response.text {
        //              print(text)
        //            }
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        
    }
    
}
