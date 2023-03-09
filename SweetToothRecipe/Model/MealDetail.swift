//
//  MealDetail.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/9/23.
//

import Foundation

/**
 A `MealDetail` struct represents detail information about a meal. This struct conforms to the `Identifiable` protocol, which allows it to be uniquely identified and used in list views.

 - Parameters:
    - id: String: A unique identifier for the meal.
    - meal: String: The name of the meal.
    - category: String?: The category of the meal, if any.
    - area: String?: The area or origin of the meal, if any.
    - instructions: String?: The instructions for preparing the meal, if available.
    - thumb: URL?: The URL of the thumbnail image for the meal, if available.
    - imageSource: URL?: The URL of the image source for the meal, if available.
    - tags: [String]: An array of tags associated with the meal.
    - youtube: URL?: The URL of the YouTube video showing how to prepare the meal, if available.
    - ingredients: [(String, String)]: An array of tuples representing the ingredients needed to prepare the meal. Each tuple contains two strings: the name of the ingredient and the corresponding measure.

 - SeeAlso: `Identifiable`
 */
struct MealDetail: Decodable, Identifiable {
    ///String identifier for the meal.
    var id: String
    ///The name of the meal.
    var meal: String
    ///The category of the meal, if any.
    var category: String?
    ///The area or origin of the meal, if any.
    var area: String?
    ///The instructions for preparing the meal, if available.
    var instructions: String?
    ///The URL of the thumbnail image for the meal, if available.
    var thumb: URL?
    ///The URL of the image source for the meal, if available.
    var imageSource: URL?
    ///An array of tags associated with the meal.
    var tags: [String]
    ///The URL of the YouTube video showing how to prepare the meal, if available.
    var youtube: URL?
    ///An array of tuples representing the ingredients needed to prepare the meal. Each tuple contains two strings: the name of the ingredient and the corresponding measure.
    var ingredients: [(String,String)]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case meal = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumb = "strMealThumb"
        case imageSource = "strImageSource"
        case tags = "strTags"
        case youtube = "strYoutube"
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        meal = try values.decode(String.self, forKey: .meal)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        area = try values.decodeIfPresent(String.self, forKey: .area)
        instructions = try values.decodeIfPresent(String.self, forKey: .instructions)
        thumb = try values.decodeIfPresent(URL.self, forKey: .thumb)
        imageSource = try values.decodeIfPresent(URL.self, forKey: .imageSource)
        
        if let tagsString = try values.decodeIfPresent(String.self, forKey: .tags) {
            tags = tagsString.components(separatedBy: ",")
        } else {
            tags = []
        }
        
        youtube = try values.decodeIfPresent(URL.self, forKey: .youtube)
        
        // Extract ingredients and measurements
        var ingredientsArray = [(String, String)]()
        for index in 1...20 {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            let ingredient = try values.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: ingredientKey)!)
            let measure = try values.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: measureKey)!)
            if let ingredient = ingredient, !ingredient.isEmpty, let measure = measure, !measure.isEmpty {
                ingredientsArray.append((ingredient, measure))
            }
        }
        ingredients = ingredientsArray
    }
}
