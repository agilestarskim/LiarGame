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
            ZStack {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack( alignment: .top, spacing: 20){
                            VStack {
                                Image("purchase1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 230)
                                    .cornerRadius(10)
                                    .shadow(color: Color(uiColor: .lightGray), radius: 4, x: 2, y: 2)
                                
                                Text("purchase1".localized)
                                    .font(.caption)
                                    .frame(width: 230, alignment: .leading)
                            }
                            
                            VStack {
                                Image("purchase2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 230)
                                    .cornerRadius(10)
                                    .shadow(color: Color(uiColor: .lightGray), radius: 4, x: 2, y: 2)
                                
                                Text("purchase2".localized)
                                    .font(.caption)
                                    .frame(width: 230, alignment: .leading)
                            }
                            VStack {
                                Image("purchase3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 230)
                                    .cornerRadius(10)
                                    .shadow(color: Color(uiColor: .lightGray), radius: 4, x: 2, y: 2)
                                
                                Text("purchase3".localized)
                                    .font(.caption)
                                    .frame(width: 230, alignment: .leading)
                            }
                            VStack {
                                Image("purchase4")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 230)
                                    .cornerRadius(10)
                                    .shadow(color: Color(uiColor: .lightGray), radius: 4, x: 2, y: 2)
                                
                                Text("purchase4".localized)
                                    .font(.caption)
                                    .frame(width: 230, alignment: .leading)
                            }
                        }
                        .padding()
                        
                        
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
                if store.showingIndicator {
                    ZStack{
                       LottieView(fileName: "Loading")
                            .frame(width: 300, height: 300)
                            .offset(x: 0, y: 80)
                    }
                }
            }
        }
        .navigationTitle("Make your own keyword".localized)
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
