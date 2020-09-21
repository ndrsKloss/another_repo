@testable import another_repo
import XCTest

final class CoordinatorAppDelegateTests:
XCTestCase {
  
  func test_coordinatorCalled() throws {
    let (sut, fields) = makeSut()
    
    _ = sut.application(
      UIApplication.shared,
      didFinishLaunchingWithOptions: nil
    )
		
		XCTAssertTrue(fields.called)
  }
}

extension CoordinatorAppDelegateTests {
  typealias Sut = CoordinatorAppDelegate
  typealias Fields = CoordinatorSpy

	final class CoordinatorSpy: Coordinatable {
		var navigationController: UINavigationController = UINavigationController()
		
		var called = false
		
		func start() {
			called = true
		}
  }
  
  func makeSut() -> (
    sut: Sut,
    fields: Fields
    ) {
      let coordinatorSpy = CoordinatorSpy()
      
      let sut = Sut(coordinator: coordinatorSpy)
      
      return (sut, coordinatorSpy)
  }
}
