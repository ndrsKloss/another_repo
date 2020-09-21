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
	
	private let coordinator: Coordinatable
	
	init(
		coordinator: Coordinatable = TopSwiftReposCoordinator()
	) {
		self.coordinator = coordinator
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		defer { window?.makeKeyAndVisible() }
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		coordinator.start()
		
		window?.rootViewController = coordinator.navigationController
		
		return true
	}
}
