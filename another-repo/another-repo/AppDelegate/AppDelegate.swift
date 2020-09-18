import UIKit

class AppDelegate:
	UIResponder,
UIApplicationDelegate {
	
	private var services: [UIApplicationDelegate]
	
	override init() {
		self.services = [CoordinatorAppDelegate()]
		super.init()
	}
	
	convenience init(
		services: [UIApplicationDelegate]
	) {
		self.init()
		self.services = services
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		for service in services {
			_ = service.application?(
				application,
				didFinishLaunchingWithOptions: launchOptions
			)
		}
		
		return true
	}
}

final class CoordinatorAppDelegate: NSObject, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		defer { window?.makeKeyAndVisible() }
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		let navigationController = UINavigationController()
		
		TopSwiftReposCoordinator(
			navigationController: navigationController
		).start()
		
		window?.rootViewController = navigationController
		
		return true
	}
}
