//
//  TwoColumnGrid.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 19.07.2025.
//

import Foundation
import SwiftUI

struct TwoColumnGrid<Content: View>: View {

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                content()
            })
        }
    }
    
}
