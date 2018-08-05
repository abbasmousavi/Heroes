//
//  HeroesUITests.swift
//  HeroesUITests
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import XCTest

class HeroesUITests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatFavoriteButtonWorksCorrectly() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier: "3-D Man").buttons["fav inactive"].tap()
        tablesQuery /* @START_MENU_TOKEN@ */ .staticTexts["3-D Man"] /* [[".cells.staticTexts[\"3-D Man\"]",".staticTexts[\"3-D Man\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()
        app.scrollViews.otherElements.buttons["fav active"].tap()
        app.buttons["close"].tap()

        XCTAssert(tablesQuery.cells.containing(.staticText, identifier: "3-D Man").buttons["fav inactive"].exists)
    }

    func testThatScrollingToTheEndOfListWillLoadMoreItems() {
        let app = XCUIApplication()
        app.tables.element(boundBy: 0).swipeUp()
        app.tables.element(boundBy: 0).swipeUp()
        app.tables.element(boundBy: 0).swipeUp()
        app.tables.element(boundBy: 0).swipeUp()
        _ = app.tables.staticTexts["Amora"].waitForExistence(timeout: 10)
        XCTAssert(app.tables.staticTexts["Amora"].exists)
    }

    func testSearchFunctionality() {
        let app = XCUIApplication()
        let searchField = app.searchFields["Search by character name"]
        searchField.tap()
        searchField.typeText("Avengers")
        app /* @START_MENU_TOKEN@ */ .buttons["Search"] /* [[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@ */ .tap()

        _ = app.tables.staticTexts["Avengers"].waitForExistence(timeout: 10)
        XCTAssert(app.tables.staticTexts["Avengers"].exists)
    }
}
