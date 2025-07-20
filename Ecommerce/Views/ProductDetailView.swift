//
//  ProductDetailView.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 19.07.2025.
//

import SwiftUI

struct ProductDetailView: View {
    
    @Environment(CartManager.self) var cartManager: CartManager
    let product: Product
    
    var body: some View {
        
        @Bindable var cartManager = cartManager
        
        
        ScrollView {
            VStack(alignment: .leading) {
                Image(product.image)
                    .bannerImageStyle()
                
                
                Group {
                    Text(product.title)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 5)
                    
                    Text(product.description)
                        .font(.system(size: 15))
                        .padding(.bottom, 15)
                    
                    
                    
                    Button {
                        cartManager.addToCart(product: product)
                        cartManager.addToCartAlert = true
                    } label: {
                        Text("Add to Cart")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                
                .padding(.horizontal)
                
                Spacer()
            }
            .alert("Added to cart", isPresented: $cartManager.addToCartAlert) {
                Button("OK") {}
            }
            message: {
                Text("You have added \(product.title) to your cart!")
            }
        }
    }
}

#Preview {
    ProductDetailView(product: ProductsClient.fetchProducts()[0])
        .environment(CartManager())
}
