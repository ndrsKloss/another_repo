// Sauce: https://jobandtalent.engineering/visualkit-ui-framework-74ab8aae0d42
public protocol Styleable {
    associatedtype Style
    func apply(style: Style)
}
