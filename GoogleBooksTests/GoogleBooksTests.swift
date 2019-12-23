//
//  GoogleBooksTests.swift
//  GoogleBooksTests
//
//  
//

import XCTest
@testable import GoogleBooks

class GoogleBooksTests: XCTestCase {
    
    
    let gService = BookService.shared
    let cService = CoreManager.shared

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAsyncBookServiceCall() {
        var books = [Book]()
        let promise = expectation(description: "wait for service call")
        gService.getBooks(for: "green") {bks in
            books = bks
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssert(books.count > 0)
    }
    
    func testCheckDelete() {
        var books = [Book]()
        let bookId: String
        let bookTitle: String
        
        let promise = expectation(description: "wait for service call")
        gService.getBooks(for: "green") {bks in
            books = bks
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        bookId = books[0].id
        bookTitle = books[0].info?.title ?? ""
        cService.save(books[0])
        cService.delete(books[0])
        XCTAssertNotEqual(cService.read(bookId)?.title, bookTitle)
    }

    
    
}
