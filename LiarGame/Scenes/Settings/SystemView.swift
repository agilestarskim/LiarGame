//
//  SystemView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/22.
//

import SwiftUI

struct SystemView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) private var dismiss
    let title: String
    @State var originalKeywords: [String]
    @State var keywords: [String]
    @State private var showingBackAlert = false
    @State private var showingResetAlert = false
    
    init(title: String, keywords: [String]) {
        self.title = title
        self._keywords = State(initialValue: keywords)
        self._originalKeywords = State(initialValue: keywords)
    }
    var body: some View {
        List {
            Section {
                Text(title)
                    .bold()
            }
            
            Section {
                ForEach(keywords.indices, id: \.self) { index in
                    TextField("Please enter the keyword".localized, text: $keywords[index])
                        .autocorrectionDisabled(true)
                }
                .onDelete { indexSet in
                    withAnimation {
                        keywords.remove(atOffsets: indexSet)
                    }
                }
                Button("Add".localized) {
                    withAnimation {
                        keywords.append("")
                    }
                }
            } header: {
                Text("You can modify, add, and delete words.".localized)
            } footer: {
                Text("You can delete the word by pushing it to the left.".localized)
            }
            
            Section {
                Button("Save".localized) {
                    save()
                }
                .disabled(checkCount || checkDuplicate || checkEdit)
                //TODO: 키워드가 10개 이상인지 확인
            } footer: {
                if checkEdit {
                    Text("There is no modified content.".localized)
                        .foregroundColor(.red)
                } else if checkCount {
                    Text("You need more than 10 keywords. Please add keywords.".localized)
                        .foregroundColor(.red)
                } else if checkDuplicate {
                    Text("Duplicate keywords exist. Please change or delete them.".localized)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Edit mode".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit".localized) {
                    if self.originalKeywords == self.keywords {
                        dismiss()
                        return
                    } else {
                        showingBackAlert = true
                    }
                }
                .alert("Are you sure you want to exit editing?".localized, isPresented: $showingBackAlert) {
                    Button("Cancel".localized, role: .cancel){}
                    Button("Exit".localized, role: .destructive){ dismiss() }
                } message: {
                    Text("If you exit, The data you just edited will not be saved.".localized)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reset".localized) {
                    showingResetAlert = true
                }
                .alert("Would you like to reset everything?".localized, isPresented: $showingResetAlert) {
                    Button("Cancel".localized, role: .cancel){}
                    Button("Reset".localized, role: .destructive) {
                        keywords = Keyword.defaultKeywords[title, default: []]
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var checkCount: Bool {
        let filteredEmptyElements = keywords.filter { !$0.isEmpty }
        return filteredEmptyElements.count < 10
    }
    
    var checkDuplicate: Bool {
        Set(keywords.map {$0.trimmingCharacters(in: .whitespaces)}).count != keywords.map{$0.trimmingCharacters(in: .whitespaces)}.count
    }
    
    var checkEdit: Bool {
        self.originalKeywords.map {$0.trimmingCharacters(in: .whitespaces)} == self.keywords.map {$0.trimmingCharacters(in: .whitespaces)}
    }
    
    private func save() {
        game.keyword.save(key: self.title, value: self.keywords, for: .system)
        game.keyword = Keyword()
        dismiss()
    }
}

struct SystemView_Previews: PreviewProvider {
    static var previews: some View {
        SystemView(title: "", keywords: [])
    }
}
