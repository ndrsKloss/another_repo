import UIKit

class AppDelegate:
	UIResponder,
UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
    defer { window?.makeKeyAndVisible() }
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = TopSwiftReposViewController()
    window?.rootViewController = viewController
		
		return true
	}
}

