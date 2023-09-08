

import Foundation
import Supabase
class QuizManager: ObservableObject {
    
    @Published var questions = [Question]()
    @Published var quizResult = QuizResult(correct: 0, total: 0, grade: "100%")
    
    
//    @Published var mockQuestions = [
//
//        Question(title: "Where the i phone was released ? ", answer: "A", options: ["A" , "B" , "C" , "D"]),
//
//        Question(title: "Where the i phone was released ? ", answer: "A", options: ["A" , "B" , "C" , "D"]),
//
//
//        Question(title: "Where the i phone was released ? ", answer: "A", options: ["A" , "B" , "C" , "D"]),
//
//        Question(title: "Where the i phone was released ? ", answer: "A", options: ["A" , "B" , "C" , "D"])
//
//
//
//    ]
    
let client = SupabaseClient(supabaseURL: URL(string: "https://fjkbysduiigogqneuwko.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqa2J5c2R1aWlnb2dxbmV1d2tvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxNjIxMTQsImV4cCI6MjAwOTczODExNH0.yxeKKg0Pp8H-RuUtXSZSCdQW32ySVyT-qFHlqgxOtVA")
    
    
    init() {
        Task{

            do{
                let response =  try await client.database.from("quiz").select().execute()
                let data = response.underlyingResponse.data
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let questions = try decoder.decode([Question].self, from: data)
                
                await MainActor.run {
                    self.questions = questions
                }
                
            }catch{
                print("Error in featching data")
            }
            
            
            
            
            
        }
    }
    
    func canSubmitQuiz ( ) -> Bool {
        return questions.filter ({ $0.selection == nil }).isEmpty
        
    }
    
    
    
    
    func gradeQuiz() {
        var correct: CGFloat = 0
        for question in questions {
            if (question.answer == question.selection){
                correct += 1
            }
        }
        
        self.quizResult = QuizResult (correct: Int(correct), total: questions.count, grade:
        "\((correct/CGFloat (questions.count)) * 100)%")
    }
    
    
    
    func resetQuiz() {
        self.questions = questions.map({Question(id: $0.id, title: $0.title, answer:
                                                    $0.answer, options: $0.options, selection: nil)})
        }
    
}


struct QuizResult {
    let correct: Int
    let total: Int
    let grade: String
}
