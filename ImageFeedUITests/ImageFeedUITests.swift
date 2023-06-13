//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Belenkow on 08.06.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит их выполнение, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("login")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("password")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        cell.swipeUp()
        cell.waitForExistence(timeout: 5)

        tablesQuery.children(matching: .cell).element(boundBy: 2).swipeDown()
        
        cell.waitForExistence(timeout: 5)
        cell.buttons["Like"].tap()
        cell.waitForExistence(timeout: 5)
        cell.buttons["Like"].tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cell.tap()

        let image = app.scrollViews.images.element(boundBy: 0)
        image.waitForExistence(timeout: 5)
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(3)

        let back = app.buttons["Back"]
        back.tap()

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        app.waitForExistence(timeout: 5)
        
        let tabBar = app.tabBars.buttons.element(boundBy: 1)
        tabBar.waitForExistence(timeout: 5)
        tabBar.tap()
        
        let logout = app.buttons["Logout"]
        logout.tap()
        
        let alert = app.alerts["Alert"].scrollViews.otherElements.buttons["Да"]
        alert.waitForExistence(timeout: 5)
        alert.tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}

