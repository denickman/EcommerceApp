//
//  BannerImageModifier.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 17.07.2025.
//

import Foundation
import SwiftUI

extension Image {
    
    func bannerImageStyle() -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: 250)
            .clipped()
    }
}
