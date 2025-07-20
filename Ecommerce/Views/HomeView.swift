//
//  HomeView.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 17.07.2025.
//

import SwiftUI

struct HomeView: View {
    
    @State var viewModel = HomeViewModel()
    @Environment(CartManager.self) var cartManager: CartManager
    @Environment(TabManager.self) var tabManager: TabManager
    
    fileprivate var NavigationBarView: some View {
        HStack {
            Spacer()
            Text("Ecommerce App")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button {
                tabManager.selectedTab = 2
            } label: {
                ZStack {
                    Image(systemName: "cart.fill")
                        .foregroundStyle(.black)
                    
                    if cartManager.displayTotalCartQuantity > 0 {
                        ZStack {
                            Circle()
                            Text("\(cartManager.displayTotalCartQuantity)")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                        .offset(CGSize(width: 10, height: -10))
                    }
                }
            }
            .padding(.trailing)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationBarView
                    
                    Image("banner")
                        .bannerImageStyle()
                    
                    HStack {
                        Text("Featured")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.leading)
                        
                        Spacer()
                        
                        NavigationLink(destination: ProductGridView(filter: .highlyRated)) {
                            Text("View All")
                                .font(.system(size: 15, weight: .bold))
                                .padding(.trailing)
                        }
                    }
                    .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.fetchProducts(filter: .isFeatured)) { product in
                                ProductRow(product: product)
                            }
                        }
                    }
                    .padding(.leading, 5)
                    
                    
                    HStack {
                        Text("Highly rated")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.leading)
                        
                        Spacer()
                        
                        NavigationLink(destination: ProductGridView(filter: .all)) {
                            Text("View All")
                                .font(.system(size: 15, weight: .bold))
                                .padding(.trailing)
                        }
                    }
                    .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.fetchProducts(filter: .highlyRated)) { product in
                                ProductRow(product: product)
                            }
                        }
                    }
                    .padding(.leading, 5)
                    
                    
                    Button {
                        viewModel.showAllProducts = true
                    } label: {
                        Text("See full catalog")
                        
                        
                            
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $viewModel.showAllProducts) {
                ProductGridView(filter: .isFeatured)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(CartManager())
        .environment(TabManager())
}
