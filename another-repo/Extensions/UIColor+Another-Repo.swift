import UIKit

public extension UIColor {
    func lighter(
		_ amount : CGFloat = 0.465
	) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    func darker(
		_ amount : CGFloat = 0.465
		) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(
		_ amount: CGFloat
	) -> UIColor {
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
		
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        }
		
		return self
    }
}
