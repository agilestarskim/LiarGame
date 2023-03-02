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
                    Text("Tip 2".localized).bold()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Image("rule3")
                        .resizable()
                        .scaledToFit()
                        
                    Text("Rule Description3".localized)
                    Text("Tip 3".localized).bold()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Image("rule4")
                        .resizable()
                        .scaledToFit()
                        
                    Text("Rule Description4".localized)
                    Text("Tip 4".localized).bold()
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
