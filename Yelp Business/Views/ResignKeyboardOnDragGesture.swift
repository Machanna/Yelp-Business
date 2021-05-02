//
//  ResignKeyboardOnDragGesture.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
