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
    @FocusState private var focusedReminder: Int?
    
    init(title: String, keywords: [String]) {
        self._title = State(initialValue: title)
        self._originalTitle = State(initialValue: title)
        
        self._keywords = State(initialValue: keywords)
        self._originalKeywords = State(initialValue: keywords)
    }
    
    var body: some View {
        List {
            Section {
                Button {
                    save()
                } label: {
                    Text("Save".localized)
                        .foregroundColor(checkAll ? Color.gray : Color.white)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(checkAll ? Color.white : Color.accentColor)
                .disabled(checkAll)
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
            Section {
                TextField("Enter the title. ex)sports".localized, text: $title)
            }
            
            Section {
                ForEach(keywords.indices, id: \.self) { index in
                    //TODO: 백그라운드 터치 시 키보드 내려가기, return 키 누를 때 키보드 up&down 하는 것 막기
                    TextField("Please enter the keyword".localized, text: $keywords[index])
                        .autocorrectionDisabled(true)
                        .focused($focusedReminder, equals: index)
                        .onSubmit {
                            if keywords.filter({ $0.isEmpty }).isEmpty {
                                focusedReminder = nil
                            } else {
                                focusedReminder = index + 1
                            }
                        }
                        .submitLabel(.next)
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
            
        }
        .navigationTitle("Edit mode".localized)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Exit".localized) {
                    if checkEdit {
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
                //추가 버튼을 눌러 들어와 생성되지 않은 데이터를 삭제하는 것을 방지
                .disabled(!game.customSubjects.contains(originalTitle))
                .alert("Would you like to Delete?".localized, isPresented: $showingRemoveAlert) {
                    Button("Cancel".localized, role: .cancel){}
                    Button("Delete".localized, role: .destructive){ remove() }
                }
            }
        }
        //백그라운드를 누를 시 키보드 내려감
        
        .navigationBarBackButtonHidden(true)
    }
    
    var checkAll: Bool {
        checkCount || checkDuplicate || checkEdit || checkDuplicateKey || checkEmptyTitle
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
        game.wholeSubjects.filter {$0 != self.originalTitle }.contains(title.trimmingCharacters(in: .whitespaces))
    }
    
    var checkEmptyTitle: Bool {
        title.isEmpty
    }
    
    //originalTitle을 파라미터로 넘기는 이유는
    //원래제목과 바뀐제목을 비교해서 제목이 수정되었다면 이전 이름으로 된 데이터를 지우고 저장하기 위해서이다.
    private func save() {
        game.save(
            key: self.title.trimmingCharacters(in: .whitespaces),
            value: self.keywords,
            for: .custom,
            originalTitle: self.originalTitle
        )
        dismiss()
    }
    
    private func remove() {
        game.remove(key: originalTitle)
        dismiss()
    }
}

struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView(title: "", keywords: [])
    }
}
