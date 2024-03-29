//
//  RuleBookView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/27.
//

import SwiftUI

struct RuleBookView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("How to play".localized)
                    .font(.largeTitle)
                    .bold()
                VStack(alignment: .leading) {
                    Image("rule1")
                        .resizable()
                        .scaledToFit()                        
                    Text("Rule Description1".localized)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Image("rule2")
                        .resizable()
                        .scaledToFit()
                    Text("Rule Description2".localized)
                    Text("Tip")
                        .foregroundColor(.black)
                        .bold()
                        .padding(5)
                        .background(.yellow)
                        .cornerRadius(5)
                        .offset(x:0, y: 15)
                    Text("Tip 2".localized).bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .cornerRadius(5)
                        
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Image("rule3")
                        .resizable()
                        .scaledToFit()
                    Text("Rule Description3".localized)
                    Text("Tip")
                        .foregroundColor(.black)
                        .bold()
                        .padding(5)
                        .background(.orange)
                        .cornerRadius(5)
                        .offset(x:0, y: 15)
                    Text("Tip 3".localized).bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .cornerRadius(5)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Image("rule4")
                        .resizable()
                        .scaledToFit()
                    Text("Rule Description4".localized)
                    
                    Text("Example")
                        .foregroundColor(.white)
                        .bold()
                        .padding(5)
                        .background(.indigo)
                        .cornerRadius(5)
                        .offset(x:0, y: 15)
                    
                    Text("Rule Example".localized)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .cornerRadius(5)
                    
                    Text("Tip")
                        .foregroundColor(.black)
                        .bold()
                        .padding(5)
                        .background(.pink)
                        .cornerRadius(5)
                        .offset(x:0, y: 15)
                    Text("Tip 4".localized).bold()
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .cornerRadius(5)
                }
            }
            .padding()
        }
    }
}

struct RuleBookView_Previews: PreviewProvider {
    static var previews: some View {
        RuleBookView()
    }
}
