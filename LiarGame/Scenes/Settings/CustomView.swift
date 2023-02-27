//
//  KeywordDetail.swift
//  LiarGame
//
//  Created by 김민성 on 2023/02/20.
//

import SwiftUI

struct CustomView: View {
    @EnvironmentObject var game: Game
    @Environment(\.dismiss) private var dismiss
    @State private var showingBackAlert = false
    @State private var showingRemoveAlert = false
    @State var title: String
    @State private var originalTitle: String
    @State var keywords: [String]
    @State private var originalKeywords: [String]
    
    init(title: String, keywords: [String]) {
        self._title = State(initialValue: title)
        self._originalTitle = State(initialValue: title)
        
        self._keywords = State(initialValue: keywords)
        self._originalKeywords = State(initialValue: keywords)
    }
    
    var body: some View {
        List {
            Section {
                TextField("Enter the title. ex)sports".localized, text: $title)
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
                .disabled(checkCount || checkDuplicate || checkEdit || checkDuplicateKey || checkEmptyTitle)
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
                } else if checkDuplicateKey {
                    Text("The same title already exists. Please change the title.".localized)
                        .foregroundColor(.red)
                } else if checkEmptyTitle {
                    Text("Please enter the title.".localized)
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
                Button("Delete".localized) {
                    showingRemoveAlert = true
                }
                .disabled(!game.keyword.customSubjects.contains(originalTitle))
                .alert("Would you like to Delete?".localized, isPresented: $showingRemoveAlert) {
                    Button("Cancel".localized, role: .cancel){}
                    Button("Delete".localized, role: .destructive){ remove() }
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
        self.originalKeywords.map {$0.trimmingCharacters(in: .whitespaces)} == self.keywords.map {$0.trimmingCharacters(in: .whitespaces)} && self.originalTitle == self.title
    }
    
    var checkDuplicateKey: Bool {
        game.keyword.wholeSubjects.filter {$0 != self.originalTitle }.contains(title)
    }
    
    var checkEmptyTitle: Bool {
        title.isEmpty
    }
    
    private func save() {
        game.keyword.save(
            key: self.title,
            value: self.keywords,
            for: .custom,
            originalTitle: self.originalTitle
        )
        game.keyword = Keyword()
        dismiss()
    }
    
    private func remove() {
        game.keyword.remove(key: originalTitle)
        game.keyword = Keyword()
        dismiss()
    }
}

struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView(title: "", keywords: [])
    }
}
