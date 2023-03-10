//
//  MealInfo.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/8/23.
//

import Foundation

/**
 A `MealInfo` struct represents general information about a meal. This struct conforms to the `Identifiable` protocol, which allows it to be uniquely identified and used in list views.

 - Parameters:
    - id: An integer identifier for the meal.
    - name: The name of the meal.
    - thumb: The URL of the thumbnail image for the meal.

 - SeeAlso: `Identifiable`
 */
struct MealInfo: Identifiable, Codable {
    ///String identifier for the meal.
    let id : String
    ///The name of the meal.
    let name : String
    ///The URL of the thumbnail imagefor the meal.
    let thumb : URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumb = "strMealThumb"
    }
}
