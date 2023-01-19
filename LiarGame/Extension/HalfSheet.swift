//
//  HalfSheet.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/18.
//

import SwiftUI

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView) -> some View {
        return self
            .background {
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            }
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    @EnvironmentObject var game: Game
    var sheetView: SheetView
    @Binding var showSheet: Bool
    let controller = UIViewController()
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet{
            let sheetController = CustomHostingController(rootView: sheetView)
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            presentationController.prefersGrabberVisible = true
        }
    }
}
