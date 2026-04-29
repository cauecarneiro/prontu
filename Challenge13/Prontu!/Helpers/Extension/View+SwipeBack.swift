import SwiftUI
import UIKit

extension View {
    /// Re-enables the interactive swipe-back gesture when the default back button is hidden.
    func enableSwipeBack() -> some View {
        background(SwipeBackEnabler())
    }
}

private struct SwipeBackEnabler: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            var responder: UIResponder? = view.next
            while let r = responder {
                if let vc = r as? UIViewController,
                   let nav = vc.navigationController {
                    nav.interactivePopGestureRecognizer?.isEnabled = true
                    nav.interactivePopGestureRecognizer?.delegate = nil
                    break
                }
                responder = r.next
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
