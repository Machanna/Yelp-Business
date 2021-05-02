//
//  Extensions.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI
import MapKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}


extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

