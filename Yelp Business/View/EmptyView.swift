//
//  EmptyView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/2/21.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Text("No Results. Please search for a different term.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
