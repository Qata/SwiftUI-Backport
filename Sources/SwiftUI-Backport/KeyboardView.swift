/// Courtesty of Prafulla Singh
/// https://medium.com/swlh/how-to-make-pure-swiftui-keyboard-toolbar-16a3d092b4df
#if canImport(SwiftUI) && os(iOS)
import SwiftUI
import Combine

@available(iOS, introduced: 13, deprecated: 14)
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    @Published private(set) var duration: Double = 0.25

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func dismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            currentHeight = height - (height < 260 ? 4 : 0)
        }
        
        if let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) {
            duration = keyboardDuration
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
        
        if let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) {
            duration = keyboardDuration
        }
    }
}

@available(iOS, introduced: 13, deprecated: 14)
public struct KeyboardView<Content: View, ToolBar: View>: View {
    @EnvironmentObject private var keyboard: KeyboardResponder
    let toolbarFrame: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 40.0)
    var content: () -> Content
    var toolBar: () -> ToolBar

    public var body: some View {
        ZStack {
            content()
                .padding(.bottom, keyboard.currentHeight == 0 ? 0 : toolbarFrame.height)
            VStack {
                Spacer()
                toolBar()
                    .frame(width: toolbarFrame.width, height: toolbarFrame.height)
                    .background(Color.secondary)
            }
            .opacity(keyboard.currentHeight == 0 ? 0 : 1)
            .animation(.easeInOut(duration: keyboard.duration))
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut)
    }
}

@available(iOS, introduced: 13, deprecated: 14)
public struct KeyboardContentModifier<Toolbar: View>: ViewModifier {
    var toolbar: () -> Toolbar

    public func body(content: Content) -> some View {
        KeyboardView(content: {
            content
        }, toolBar: {
            toolbar()
        })
        .stateObjectLegacy(KeyboardResponder())
    }
}

@available(iOS, introduced: 13, deprecated: 14)
public extension View {
    func keyboardToolbar<Toolbar: View>(_ toolbar: @escaping @autoclosure () -> Toolbar) -> some View {
        modifier(KeyboardContentModifier(toolbar: toolbar))
    }
}

@available(iOS, introduced: 13, deprecated: 14)
struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight = CGFloat.zero
    @State private var bottomInset = CGFloat.zero
    
    func body(content: Content) -> some View {
        content
            .readSafeAreaInsets {
                bottomInset = $0.bottom
            }
            .padding(.bottom, currentHeight)
            .onAppear {
                if #available(iOS 14, *) {
                    return
                }
                NotificationCenter.Publisher(
                    center: NotificationCenter.default,
                    name: UIResponder.keyboardWillShowNotification
                )
                .merge(
                    with: NotificationCenter.Publisher(
                        center: NotificationCenter.default,
                        name: UIResponder.keyboardWillChangeFrameNotification
                    )
                )
                .compactMap { notification in
                    withAnimation(.easeOut(duration: 0.16)) {
                        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    }
                }
                .map { $0.height - bottomInset }
                .merge(
                    with: NotificationCenter.Publisher(
                        center: NotificationCenter.default,
                        name: UIResponder.keyboardWillHideNotification
                    )
                    .map { _ in .zero }
                )
                .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
            }
    }
}

@available(iOS, introduced: 13, deprecated: 14)
extension View {
    func adaptsToKeyboard() -> some View {
        modifier(AdaptsToKeyboard())
    }
}
#endif
