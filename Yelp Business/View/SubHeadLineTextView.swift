//
//  SubHeadLineTextView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/2/21.
//

import SwiftUI

struct SubHeadLineTextView: View {
    var displayText: String
    
    var body: some View {
        Text(displayText)
        .font(.subheadline)
    }
}
