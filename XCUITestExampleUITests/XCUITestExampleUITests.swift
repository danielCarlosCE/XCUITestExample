//
//  XCUITestExampleUITests.swift
//  XCUITestExampleUITests
//
//  Created by Daniel Carlos on 12/2/17.
//  Copyright © 2017 Daniel Carlos. All rights reserved.
//

import XCTest

class Logger {
    func log(_ m: String) {
        print(m)
    }
}

class Page {
    typealias Completion = (() -> Void)?
    let app = XCUIApplication()
    let log = Logger().log
    required init(timeout: TimeInterval = 10, completion: Completion = nil) {
        log("waiting \(timeout)s for \(String(describing: self)) existence")
        XCTAssert(rootElement.waitForExistence(timeout: timeout),
                  "Page \(String(describing: self)) waited, but not loaded")
        completion?()
    }
    var rootElement: XCUIElement {
        fatalError("subclass should override rootElement")
    }
}

class SearchPage: Page {
    override var rootElement: XCUIElement {
        return app.otherElements["view_search"]
    }
    
    @discardableResult
    func type(query: String, completion: Completion = nil) -> Self {
        log("type \(query) in search field")
        let inputSearch = app.textFields["input_search"]
        inputSearch.tap()
        inputSearch.typeText(query)
        completion?()
        return self
    }
    
    @discardableResult
    func tapOk(completion: Completion = nil) -> ResultPage {
        log("tap on ok button")
        app.buttons["btn_ok"].tap()
        return ResultPage(completion: completion)
    }
    
}

class ResultPage: Page {
    override var rootElement: XCUIElement {
        return app.otherElements["view_result"]
    }
    
    @discardableResult
    func getTitle(completion: (String) -> Void) -> Self {
        completion(app.staticTexts["text_title"].label)
        return self
    }
}

extension XCTestCase {
    func takeScreenShot(name screenshotName: String? = nil) {
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot, quality: .original)
        attach.name = screenshotName ?? name + "_" + UUID().uuidString
        attach.lifetime = .keepAlways
        add(attach)
    }
}

class XCUITestExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testSearchResultFlow() {
        SearchPage()
            .type(query: "XCode") { self.takeScreenShot() }
            .tapOk()
            .getTitle {
                XCTAssertEqual("Result for XCode", $0)
            }
    }
    
    override func tearDown() {
        takeScreenShot()
    }
    
}
