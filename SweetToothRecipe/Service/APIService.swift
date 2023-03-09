//
//  APIService.swift
//  SweetToothRecipe
//
//  Created by Gefei Shen on 3/8/23.
//

import Foundation

/**
 API service for SweetToothRecipe.
 */

class APIService {
    //API endpoint
    let baseURL = "https://themealdb.com/api/json/v1/1"
    var session : URLSession
    
    /**
     Initializes a new instance of the APIService.
         
     - Parameters:
        - session: The URL session to use for network requests. Defaults to URLSession.shared.
     */
    init(session : URLSession = URLSession.shared) {
        self.session = session
    }
    
    /**
     Retrieves a list of desserts from the MealDB API.
         
     - Returns: An array of MealInfo objects representing the desserts.
     - Throws: An error if there was a problem with the network request or decoding the response.
     */
    func getDessert() async throws -> [MealInfo] {
        guard let url = URL(string: "\(baseURL)/filter.php?c=Dessert") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Server Error", code: 0, userInfo: nil)
        }
        
        var meals : [MealInfo] = []
        meals = try JSONDecoder().decode(MealInfoResponse.self, from: data).meals
        
        return meals
    }
}

///Response format for getDessert()
struct MealInfoResponse: Codable {
    var meals : [MealInfo]
}
