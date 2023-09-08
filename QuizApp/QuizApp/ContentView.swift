//
//  ContentView.swift
//  QuizApp
//
//  Created by Mac on 05/09/2023.
//

import SwiftUI


struct ContentView: View {
    @StateObject var manager = QuizManager()
    
    @State var selection = 0 // when Restart the quiz back to first oqustion
    @State var showStart = true
    @State var showResult = false
    var body: some View {
        
        TabView(selection: $selection) {
            
            ForEach(manager.questions.indices , id: \.self){index in
                
                VStack{
                    
                    QuestionView(question: $manager.questions[index])
                    
                    if let lastQuestion = manager.questions.last , lastQuestion.id ==
                        manager.questions[index].id{


                        Button{
                             manager.gradeQuiz()
                             showResult = true
                             manager.resetQuiz()
                             selection = 0 //first page (first question)
                        } label: {
                            Text ("Submit")
                                .padding ()
                                .foregroundColor(.white)
                                .background {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous )
                                        .fill(Color("Color"))
                                        .frame(width:340)
                                }
                        }
//                        buttonStyle(.plain)
//                        disabled(!manager.canSubmitQuiz())

                    }
                    
                }
                .tag(index)
            }
            
        }
        .tabViewStyle(.page)
        .fullScreenCover(isPresented: $showStart){
            StartView()
            }
        
        .fullScreenCover(isPresented: $showResult){
            ResultsView(result: manager.quizResult)

        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
