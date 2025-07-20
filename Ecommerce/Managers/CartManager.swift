//
//  CartManager.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 19.07.2025.
//

import Foundation
import SwiftUI

@Observable
class CartManager {
    
    var productsInCart: [ProductInCart] = []
    var addToCartAlert = false
    
    var displayTotalCartPrice: String {
//        var totalPrice = 0
//        for productInCart in productsInCart {
//            let total = productInCart.quantity * productInCart.product.price
//            totalPrice += total
//        }

       let totalPrice = productsInCart.reduce(0) {
            $0 + ($1.quantity * $1.product.price)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: totalPrice as NSNumber) ?? "$0.00"
    }
    
    var displayTotalCartQuantity: Int {
//        var totalQuantity = 0
//        for productInCart in productsInCart {
//            totalQuantity += productInCart.quantity
//        }
//        return totalQuantity
        
        productsInCart.reduce(0) {
            $0 + $1.quantity
        }
    }
    
    func addToCart(product: Product) {
        if let indexProductInCart = productsInCart.firstIndex(where: { $0.id == product.id }) {
            let currentQuantity = productsInCart[indexProductInCart].quantity
            let newQuantity = currentQuantity + 1
            
            let updatedProductInCart = ProductInCart(product: product, quantity: newQuantity)
            productsInCart[indexProductInCart] = updatedProductInCart
        } else {
            productsInCart.append(ProductInCart(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(product: Product) {
        if let indexOfProductInCart = productsInCart.firstIndex(where: { $0.id == product.id }) {
            let currentQuantity = productsInCart[indexOfProductInCart].quantity
            if currentQuantity > 1 {
                let newQuantity = currentQuantity - 1
                let updatedProductInCart = ProductInCart(product: product, quantity: newQuantity)
                productsInCart[indexOfProductInCart] = updatedProductInCart
            } else {
                productsInCart.remove(at: indexOfProductInCart)
            }
           
        }
    }
}

