//
//  SweetToothRecipeUITests.swift
//  SweetToothRecipeUITests
//
//  Created by Gefei Shen on 3/9/23.
//

import XCTest

final class SweetToothRecipeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /**
     Basic UI test for MealListView and MealDetailView, simulates user interaction, keeps a screenshot for each view
     */
    func testNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let mealListNavigationBar = app.navigationBars["Desserts"]
        XCTAssertTrue(mealListNavigationBar.exists)
        
        let mealListCollection = app.collectionViews.firstMatch
        XCTAssertTrue(mealListCollection.waitForExistence(timeout: 5))
        
        mealListCollection.swipeUp()

        let mealListLastCell = mealListCollection.cells.element(boundBy: mealListCollection.cells.count-1)
        if !mealListLastCell.isHittable {
            mealListCollection.swipeUp()
        }
        XCTAssertTrue(mealListLastCell.waitForExistence(timeout: 5))
        
        takeScreenshot(named: "MealList")

        mealListLastCell.tap()

        //MealDetail View
        let mealDetailNavigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(mealDetailNavigationBar.waitForExistence(timeout: 5))
        
        takeScreenshot(named: "MealDetail")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(mealListNavigationBar.exists)
    }
    
    /**
     A helper function to take screenshot and store permanently
        - Parameters:
        - name: Name of the screenshot in String
     */
    func takeScreenshot(named name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)
            
        screenshotAttachment.lifetime = .keepAlways
        
        add(screenshotAttachment)
    }
}
