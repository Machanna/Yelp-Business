//
//  CategoriesView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/2/21.
//

import SwiftUI

struct CategoriesView: View {
    
    var categories : [Category]
    
    var body: some View {
        HStack {
            ForEach(categories, id:\.id) { category in
                Text(category.title)
                    .font(.caption)
             }
        }
    }
}

