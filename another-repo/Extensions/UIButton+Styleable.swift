import UIKit

public struct UIButtonStyle {
	let contentEdgeInsets: UIEdgeInsets
	let cornerRadius: CGFloat
	let borderWidth: CGFloat
	let masksToBounds: Bool
	let font: UIFont
	let titleColor: UIColor
	let backgroundColor: UIColor
	let translatesAutoresizingMaskIntoConstraints: Bool
	
	init(
		contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: .small, left: .small, bottom: .small, right: .small),
		cornerRadius: CGFloat = .smallx,
		borderWidth: CGFloat = .smallxx,
		masksToBounds: Bool = true,
		font: UIFont = UIFont.systemFont(ofSize: .mediumx, weight: .medium),
		titleColor: UIColor,
		backgroundColor: UIColor = .white,
		translatesAutoresizingMaskIntoConstraints: Bool = false
	) {
		self.contentEdgeInsets = contentEdgeInsets
		self.cornerRadius = cornerRadius
		self.masksToBounds = masksToBounds
		self.borderWidth = borderWidth
		self.font = font
		self.titleColor = titleColor
		self.backgroundColor = backgroundColor
		self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
	}
	
	static var normal = UIButtonStyle(titleColor: .systemGray)
	static var error = UIButtonStyle(titleColor: .systemGray2)
}

extension UIButton: Styleable {
    public func apply(style: UIButtonStyle) {
		contentEdgeInsets = style.contentEdgeInsets
		layer.cornerRadius = style.cornerRadius
		layer.masksToBounds = style.masksToBounds
		layer.borderWidth = style.borderWidth
		layer.borderColor = style.titleColor.cgColor
		titleLabel?.font = style.font
		setTitleColor(style.titleColor, for: .normal)
		setTitleColor(style.titleColor.darker(), for: .highlighted)
		backgroundColor = style.backgroundColor
		translatesAutoresizingMaskIntoConstraints = style.translatesAutoresizingMaskIntoConstraints
    }
}
