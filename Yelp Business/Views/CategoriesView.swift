//
//  CategoriesView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    
    var business : Business
    
    var body: some View {
        HStack {
            ForEach(0..<business.categories.count) { i in

                Text(business.categories[i].title )
                    .font(.caption)
             }
        }
    }
}

