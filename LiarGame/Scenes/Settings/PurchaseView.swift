//
//  PerchaseView.swift
//  LiarGame
//
//  Created by 김민성 on 2023/03/12.
//

import SwiftUI
import LinkNavigator

struct PurchaseView: View {
    @EnvironmentObject var store: Store
    @State private var showingErrorMessage = false
    let navigator: LinkNavigatorType
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("Make your own keyword".localized)
                    .font(.largeTitle.bold())
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        Color.black
                            .frame(width: 300, height: 500)
                            .cornerRadius(10)
                        Color.black
                            .frame(width: 300, height: 500)
                            .cornerRadius(10)
                        Color.black
                            .frame(width: 300, height: 500)
                            .cornerRadius(10)
                    }
                    
                }
                .padding()
                Button {
                    Task {
                        await purchase()
                    }
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Continue".localized)
                            .font(.largeTitle.bold())
                        Text(store.price)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()                        
                }
                
                
                HStack {
                    Text("Did you buy it before?".localized)
                    Button("Restore Purchases".localized) {
                        Task {
                            await store.updateCustomerProductStatus()
                            if store.isPurchased {
                                navigator.next(paths: ["keyword"], items: [:], isAnimated: true)
                                navigator.remove(paths: ["purchase"])
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel".localized) {
                    navigator.rootBackOrNext(path: "setting", items: [:], isAnimated: true)
                }
            }
        }
        .toast(message: "Error", isShowing: $showingErrorMessage, config: .init())
    }
    
    @MainActor
    func purchase() async {
        do {
            if try await store.purchase() != nil {                
                navigator.next(paths: ["keyword"], items: [:], isAnimated: true)
                navigator.remove(paths: ["purchase"])
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

struct PurchaseRouteBuilder: RouteBuilder {
  var matchPath: String { "purchase" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
      return WrappingController(matchPath: matchPath) {
          PurchaseView(navigator: navigator)
      }
    }
  }
}



struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(navigator: LinkNavigator(dependency: AppDependency(), builders: []))
            .environmentObject(Store())
    }
}
