//
//  ProductRow.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 18.07.2025.
//

import SwiftUI

struct ProductRow: View {
    
    @Environment(FavoritesManager.self) var favoritesManager: FavoritesManager
    let product: Product
    
    
    var body: some View {
        NavigationLink {
            ProductDetailView(product: product)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Image(product.image)
                    .resizable()
                        .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 8, bottomLeading: .zero, bottomTrailing: .zero, topTrailing: 8)))
                
                Group {
                    Text(product.title)
                        .lineLimit(1)
                        .foregroundStyle(.black)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Text(product.displayPrice)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black)
                        .scaledToFill()
                        
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                        
                        Text(product.displayRating)
                            .foregroundStyle(.black)
                            .font(.system(size: 14))
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(width: 150, height: 270)
            .overlay(alignment: .topTrailing, content: {
                Button {
                    if favoritesManager.products.contains(product) {
                        favoritesManager.products.removeAll(where: {
                            $0.id == product.id
                        })
                    } else {
                        favoritesManager.products.append(product)
                    }
                } label: {
                    Image(systemName: favoritesManager.products.contains(product) ? "heart.fill" : "heart")
                    
                }
                .padding(8)
            })
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.5), lineWidth: 2.0)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProductRow(product: ProductsClient.fetchProducts()[0])
            .environment(FavoritesManager())
    }
}
