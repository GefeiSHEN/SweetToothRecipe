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
    
    func testGetDessertDetailSuccess() async throws {
        // Given
        let mealId = "52854"
        let data = """
                {
                    "meals": [
                        {
                            "idMeal": "52854",
                            "strMeal": "Pancakes",
                            "strDrinkAlternate": null,
                            "strCategory": "Dessert",
                            "strArea": "American",
                            "strInstructions": "Put the flour, eggs, milk, 1 tbsp oil and a pinch of salt into a bowl or large jug, then whisk to a smooth batter. Set aside for 30 mins to rest if you have time, or start cooking straight away.\\r\\nSet a medium frying pan or cr\\u00eape pan over a medium heat and carefully wipe it with some oiled kitchen paper. When hot, cook your pancakes for 1 min on each side until golden, keeping them warm in a low oven as you go.\\r\\nServe with lemon wedges and sugar, or your favourite filling. Once cold, you can layer the pancakes between baking parchment, then wrap in cling film and freeze for up to 2 months.",
                            "strMealThumb": "https:\\/\\/www.themealdb.com\\/images\\/media\\/meals\\/rwuyqx1511383174.jpg",
                            "strTags": "Breakfast,Desert,Sweet,Fruity",
                            "strYoutube": "https:\\/\\/www.youtube.com\\/watch?v=LWuuCndtJr0",
                            "strIngredient1": "Flour",
                            "strIngredient2": "Eggs",
                            "strIngredient3": "Milk",
                            "strIngredient4": "Sunflower Oil",
                            "strIngredient5": "Sugar",
                            "strIngredient6": "Raspberries",
                            "strIngredient7": "Blueberries",
                            "strIngredient8": "",
                            "strIngredient9": "",
                            "strIngredient10": "",
                            "strIngredient11": "",
                            "strIngredient12": "",
                            "strIngredient13": "",
                            "strIngredient14": "",
                            "strIngredient15": "",
                            "strIngredient16": "",
                            "strIngredient17": "",
                            "strIngredient18": "",
                            "strIngredient19": "",
                            "strIngredient20": "",
                            "strMeasure1": "100g",
                            "strMeasure2": "2 large",
                            "strMeasure3": "300ml",
                            "strMeasure4": "1 tbls",
                            "strMeasure5": "to serve",
                            "strMeasure6": "to serve",
                            "strMeasure7": "to serve",
                            "strMeasure8": "",
                            "strMeasure9": "",
                            "strMeasure10": "",
                            "strMeasure11": "",
                            "strMeasure12": "",
                            "strMeasure13": "",
                            "strMeasure14": "",
                            "strMeasure15": "",
                            "strMeasure16": "",
                            "strMeasure17": "",
                            "strMeasure18": "",
                            "strMeasure19": "",
                            "strMeasure20": "",
                            "strSource": "https:\\/\\/www.bbcgoodfood.com\\/recipes\\/2907669\\/easy-pancakes",
                            "strImageSource": null,
                            "strCreativeCommonsConfirmed": null,
                            "dateModified": null
                        }
                    ]
                }
            """.data(using: .utf8)!
        
        let url = try XCTUnwrap(URL(string: "\(sut.baseURL)/lookup.php?i=\(mealId)"))
        URLProtocolMock.testURLs[url] = (data: data, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        sut.session = session
        
        // When
        let meal = try await sut.getDessertDetail(mealId: mealId)

        // Then
        XCTAssertEqual(meal.id, "52854")
        XCTAssertEqual(meal.name, "Pancakes")
        XCTAssertEqual(meal.category, "Dessert")
        XCTAssertEqual(meal.area, "American")
        XCTAssertEqual(meal.instructions, "Put the flour, eggs, milk, 1 tbsp oil and a pinch of salt into a bowl or large jug, then whisk to a smooth batter. Set aside for 30 mins to rest if you have time, or start cooking straight away.\r\nSet a medium frying pan or crêpe pan over a medium heat and carefully wipe it with some oiled kitchen paper. When hot, cook your pancakes for 1 min on each side until golden, keeping them warm in a low oven as you go.\r\nServe with lemon wedges and sugar, or your favourite filling. Once cold, you can layer the pancakes between baking parchment, then wrap in cling film and freeze for up to 2 months.")
        XCTAssertEqual(meal.thumb?.absoluteString, "https://www.themealdb.com/images/media/meals/rwuyqx1511383174.jpg")
        XCTAssertEqual(meal.tags, ["Breakfast", "Desert", "Sweet", "Fruity"])
        XCTAssertEqual(meal.youtube?.absoluteString, "https://www.youtube.com/watch?v=LWuuCndtJr0")
        let ingredients = [Ingredient(name: "Flour", amount: "100g"), Ingredient(name: "Eggs", amount: "2 large"), Ingredient(name: "Milk", amount: "300ml"), Ingredient(name: "Sunflower Oil", amount: "1 tbls"), Ingredient(name: "Sugar", amount: "to serve"), Ingredient(name: "Raspberries", amount: "to serve"), Ingredient(name: "Blueberries", amount: "to serve")]
        XCTAssertEqual(meal.ingredients, ingredients)
    }
    
    func testGetDessertDetailServerFailure() async throws {
        // Given
        let mealId = "1234"
        let url = try XCTUnwrap(URL(string: "\(sut.baseURL)/lookup.php?i=\(mealId)"))
        URLProtocolMock.testURLs[url] = (data: Data(), response: HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!)
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        sut.session = session
        
        // Then
        do {
            _ = try await sut.getDessertDetail(mealId: mealId)
            XCTFail("Expected error, but no error was thrown.")
        } catch (let error) {
            XCTAssertEqual((error as NSError).domain, "Server Error")
            XCTAssertEqual((error as NSError).code, 0)
        }
    }
}
