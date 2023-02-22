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
                    TextField("키워드를 입력하세요", text: $keywords[index])
                        .autocorrectionDisabled(true)
                }
                .onDelete { indexSet in
                    withAnimation {
                        keywords.remove(atOffsets: indexSet)
                    }
                }
                Button("추가") {
                    withAnimation {
                        keywords.append("")
                    }
                }
            } header: {
                Text("단어를 수정하거나 추가 삭제할 수 있습니다.")
            } footer: {
                Text("단어를 왼쪽으로 밀어 삭제할 수 있습니다.")
            }
            
            Section {
                Button("저장") {
                    save()
                }
                .disabled(checkCount || checkDuplicate || checkEdit)
                //TODO: 키워드가 10개 이상인지 확인
            } footer: {
                if checkEdit {
                    Text("수정된 내용이 없습니다.")
                        .foregroundColor(.red)
                } else if checkCount {
                    Text("키워드는 10개 이상 필요합니다. 키워드를 추가하세요")
                        .foregroundColor(.red)
                } else if checkDuplicate {
                    Text("중복된 키워드가 존재합니다. 변경하거나 삭제해주세요")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("키워드 수정")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    if self.originalKeywords == self.keywords {
                        dismiss()
                        return
                    } else {
                        showingBackAlert = true
                    }
                }
                .alert("취소하시겠습니까?", isPresented: $showingBackAlert) {
                    Button("취소하기", role: .destructive){ dismiss() }
                    Button("계속하기", role: .cancel){}
                } message: {
                    Text("취소하시면 작성한 데이터는 모두 사라집니다.")
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
