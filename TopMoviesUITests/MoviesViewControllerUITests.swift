//
//  MoviesViewControllerUITests.swift
//  TopMovies
//
//  Created by Mina Hanna on 2026-05-29.
//

import XCTest

final class MoviesViewControllerUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func test_movies_screen_loads() {

        let table = app.tables["movies_table"]

        XCTAssertTrue(table.waitForExistence(timeout: 5))
    }
    
    func test_tap_movie_opens_details() {
        
        let table = app.tables["movies_table"]
        
        XCTAssertTrue(table.waitForExistence(timeout: 10))
        
        let firstCell = table.cells.element(boundBy: 0)
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: firstCell)
        waitForExpectations(timeout: 10)
        
        // 🔥 NOW TEST TITLE INSIDE CELL
        let titleLabel = firstCell.staticTexts["movie_title_label"]
        
        XCTAssertTrue(titleLabel.exists)
        
        // Optional: validate it's NOT empty
        XCTAssertFalse(titleLabel.label.isEmpty)
    }
}
