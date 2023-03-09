//
//  MealInfo.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/8/23.
//

import Foundation

/**
 A `MealInfo` struct represents general information about a meal. This struct conforms to the `Identifiable` protocol, which allows it to be uniquely identified and used in list views.

 - Note: The `uuid` property is used to conform to the `Identifiable` protocol and provide a unique identifier for each instance of `MealInfo`. It is automatically generated using the `UUID` type.

 - Parameters:
    - id: An integer identifier for the meal.
    - name: The name of the meal.
    - thumb: The URL of the thumbnail image for the meal.

 - SeeAlso: `Identifiable`
 */
struct MealInfo: Identifiable {
    var uuid = UUID()
    ///Integer identifier for the meal.
    var id : Int
    ///The name of the meal.
    var name : String
    ///The URL of the thumbnail imagefor the meal.
    var thumb : URL
}
