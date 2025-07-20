//
//  ProductCart.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 19.07.2025.
//

import Foundation
import SwiftUI

struct ProductInCart: Identifiable {
    var id: String {
        product.id
    }
    let product: Product
    var quantity: Int
}
