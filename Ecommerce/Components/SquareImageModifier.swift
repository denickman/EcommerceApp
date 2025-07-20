//
//  SquareImageModifier.swift
//  Ecommerce
//
//  Created by Denis Yaremenko on 19.07.2025.
//

import Foundation
import SwiftUI

extension Image {
    func squareImageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
    }
}
