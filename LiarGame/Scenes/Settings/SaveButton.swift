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
    @State private var showingErrorMessage = false
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
        .toast(message: "Error", isShowing: $showingErrorMessage, config: .init())
    }
    
    @MainActor
    func purchase() async {
        do {
            if try await store.purchase() != nil {
                save()
            }
        } catch StoreError.failedVerification {
            showingErrorMessage = true
            print("failedVerification")
        } catch {
            showingErrorMessage = true
            print("error")
        }
    }
}
