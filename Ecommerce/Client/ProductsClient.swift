//
//  ProductsClient.swift
//
//

import Foundation

class ProductsClient {
    
    static func fetchProducts() -> [Product] {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let products = try decoder.decode([Product].self, from: data)
            return products
        } catch {
            print("Failed to load or decode the JSON: \(error)")
            return []
        }
    }
    
}
