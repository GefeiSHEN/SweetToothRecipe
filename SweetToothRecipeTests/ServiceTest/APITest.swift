//
//  APITest.swift
//  SweetToothRecipeTests
//
//  Created by Gefei Shen on 3/8/23.
//
import XCTest
@testable import SweetToothRecipe

class APIServiceTests: XCTestCase {
    
    var sut: APIService!
    
    override func setUp() {
        super.setUp()
        sut = APIService()
        URLProtocolMock.testURLs = [:]
    }
    
    override func tearDown() {
        sut = nil
        URLProtocolMock.testURLs = [:]
        super.tearDown()
    }
    
    func testGetDessertSuccess() async throws {
        // Given
        let data = """
            {
                "meals": [
                    {
                        "idMeal": "1234",
                        "strMeal": "Apple Pie",
                        "strMealThumb": "https://www.themealdb.com/images/media/meals/applepie.jpg"
                    }
                ]
            }
        """.data(using: .utf8)!
        let url = try XCTUnwrap(URL(string: "\(sut.baseURL)/filter.php?c=Dessert"))
        URLProtocolMock.testURLs[url] = (data: data, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        sut.session = session
        
        // When
        let meals = try await sut.getDessert()
        
        // Then
        XCTAssertEqual(meals.count, 1)
        XCTAssertEqual(meals[0].id, "1234")
        XCTAssertEqual(meals[0].name, "Apple Pie")
        XCTAssertEqual(meals[0].thumb?.absoluteString, "https://www.themealdb.com/images/media/meals/applepie.jpg")
    }
    
    func testGetDessertServerFailure() async throws {
        // Given
        let url = try XCTUnwrap(URL(string: "\(sut.baseURL)/filter.php?c=Dessert"))
        URLProtocolMock.testURLs[url] = (data: Data(), response: HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!)

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        sut.session = session

        // Then
        do {
            _ = try await sut.getDessert()
            XCTFail("Expected error, but no error was thrown.")
        } catch (let error) {
            XCTAssertEqual((error as NSError).domain, "Server Error")
            XCTAssertEqual((error as NSError).code, 0)
        }
        
    }
}
