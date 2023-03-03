//
//  SaveButton.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/02.
//

import SwiftUI

struct SaveButton<Content>: View where Content: View {
    @EnvironmentObject var store: Store
    let save: () -> Void
    @ViewBuilder let content: Content
    
    var body: some View {
        Button {
            if store.isPurchased {
                save()
            } else {
                Task {
                    await purchase()
                }
            }            
        } label: {
            content
        }
    }
    
    @MainActor
    func purchase() async {
        do {
            if try await store.purchase() != nil {
                save()
            }
        } catch StoreError.failedVerification {
            //TODO: 에러메세지
            print("failedVerification")
        } catch {
            //에러프린트
            print("error")
        }
    }
}
