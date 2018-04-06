//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import XCTest
@testable import Wire

class MockOptionsViewModelConfiguration: ConversationOptionsViewModelConfiguration {

    typealias SetHandler = (Bool, (VoidResult) -> Void) -> Void
    var allowGuests: Bool
    var setAllowGuests: SetHandler?
    var allowGuestsChangedHandler: ((Bool) -> Void)?
    var title: String
    var linkResult: Result<String?>? = nil
    var deleteResult: VoidResult = .success
    var createResult: Result<String>? = nil
    var isCodeEnabled = true
    
    init(allowGuests: Bool, title: String = "", setAllowGuests: SetHandler? = nil) {
        self.allowGuests = allowGuests
        self.setAllowGuests = setAllowGuests
        self.title = title
    }

    func setAllowGuests(_ allowGuests: Bool, completion: @escaping (VoidResult) -> Void) {
        setAllowGuests?(allowGuests, completion)
    }
    
    func createConversationLink(completion: @escaping (Result<String>) -> Void) {
        createResult.apply(completion)
    }
    
    func fetchConversationLink(completion: @escaping (Result<String?>) -> Void) {
        linkResult.apply(completion)
    }
    
    func deleteLink(completion: @escaping (VoidResult) -> Void) {
        completion(deleteResult)
    }
}

final class ConversationOptionsViewControllerTests: ZMSnapshotTestCase {

    func testThatItRendersTeamOnly() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        sut.view.layer.speed = 0
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersTeamOnly_DarkTheme() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        sut.view.layer.speed = 0
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithLink() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success("https://app.wire.com/772bfh1bbcssjs982637 3nbbdsn9917nbbdaehkej827648-72bns9")
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithLink_DarkTheme() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success("https://app.wire.com/772bfh1bbcssjs982637 3nbbdsn9917nbbdaehkej827648-72bns9")
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithLink_Copying() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success("https://app.wire.com/772bfh1bbcssjs982637 3nbbdsn9917nbbdaehkej827648-72bns9")
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        viewModel.copyInProgress = true
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithLink_DarkTheme_Copying() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success("https://app.wire.com/772bfh1bbcssjs982637 3nbbdsn9917nbbdaehkej827648-72bns9")
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        viewModel.copyInProgress = true
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithoutLink() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success(nil)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersAllowGuests_WithoutLink_DarkTheme() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true)
        config.linkResult = .success(nil)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersItsTitle() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: true, title: "Italy Trip")
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        sut.view.layer.speed = 0
        
        // Then
        verify(view: sut.wrapInNavigationController().view)
    }
    
    func testThatItRendersNotTeamOnly() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItUpdatesWhenItReceivesAChange() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        config.linkResult = .success(nil)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        sut.view.layer.speed = 0
        
        XCTAssertNotNil(config.allowGuestsChangedHandler)
        config.allowGuests = true
        config.allowGuestsChangedHandler?(true)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItUpdatesWhenItReceivesAChange_Loading() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        sut.view.layer.speed = 0
        
        XCTAssertNotNil(config.allowGuestsChangedHandler)
        config.allowGuests = true
        config.allowGuestsChangedHandler?(true)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersNotTeamOnly_DarkTheme() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        
        // Then
        verify(view: sut.view)
    }
    
    func testThatItRendersLoading() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .light)
        let navigationController = sut.wrapInNavigationController()
        
        sut.loadViewIfNeeded()
        navigationController.view.layer.speed = 0
        
        // When
        viewModel.setAllowGuests(true)
        
        // Then
        verify(view: navigationController.view)
    }
    
    func testThatItRendersLoading_DarkTheme() {
        // Given
        let config = MockOptionsViewModelConfiguration(allowGuests: false)
        let viewModel = ConversationOptionsViewModel(configuration: config)
        let sut = ConversationOptionsViewController(viewModel: viewModel, variant: .dark)
        let navigationController = sut.wrapInNavigationController()
        
        sut.loadViewIfNeeded()
        navigationController.view.layer.speed = 0
        
        // When
        viewModel.setAllowGuests(true)
        
        // Then
        verify(view: navigationController.view)
    }
    
    func testThatItRendersRemoveGuestsConfirmationAlert() {
        // When & Then
        let sut = UIAlertController.confirmRemovingGuests { _ in }
        verifyAlertController(sut)
    }
    
    func testThatItRendersRevokeLinkConfirmationAlert() {
        // When & Then
        let sut = UIAlertController.confirmRevokingLink { _ in }
        verifyAlertController(sut)
    }
    
    private func verifyAlertController(_ controller: UIAlertController, file: StaticString = #file, line: UInt = #line) {
        // Given
        let window = UIWindow(frame: .init(x: 0, y: 0, width: 375, height: 667))
        let container = UIViewController()
        container.loadViewIfNeeded()
        window.rootViewController = container
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()
        
        // When
        let presentationExpectation = expectation(description: "It should be presented")
        container.present(controller, animated: false) {
            presentationExpectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        verify(view: controller.view, file: file, line: line)
    }
    
}
