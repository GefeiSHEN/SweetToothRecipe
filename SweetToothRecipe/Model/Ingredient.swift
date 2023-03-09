//
//  Ingredient.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/9/23.
//

import Foundation

/**
 A 'Ingredient' represents  an ingredient and it's amount used in a recipe.
 
 - Parameters:
    - name: Name of the ingredient in String
    - amount: Amount of the ingredient in String
 */
struct Ingredient: Equatable {
    ///Name of the ingredient in String
    let name : String
    ///Amount of the ingredient in String
    let amount: String
}
