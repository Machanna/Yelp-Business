//
//  DetailView.swift
//  Yelp Business
//  Second screen to display selected yelp business map from user's location and its details.
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI
import MapKit

struct DetailView: View {
    
    let business: Business?
    let latitude: Double
    let longitude: Double
    
    var distance: String {
        if let d = business?.distance{
            let distancInString = String(format: "%.2f", d/1000.0)
            return distancInString + " mi"
        }else{
            return ""
        }
    }
    
    var rating: Float {
        if let r = business?.rating{
            let rInt = Float(r)
            return rInt
        }else{
            return 1
        }
    }
    
    var body: some View {
        NavigationView {
                VStack(spacing: 0) {
                    MapView(business: business, latitude: latitude, longitude: longitude)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(business?.name ?? "").font(.title)
                            Spacer()
                            Text(distance)
                                .font(.subheadline)
                        }
                        RatingsView(rating: rating,reviewCount: business?.reviewCount ?? 0)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                        SubHeadLineTextView(displayText: business?.location?.displayAddress[0]  ?? "")
                        SubHeadLineTextView(displayText: business?.location?.displayAddress[1]  ?? "")
                        SubHeadLineTextView(displayText:business?.displayPhone ?? "")
                            .foregroundColor(.gray)
                        Text(business?.isClosed ?? false ? "Closed" : "Open")
                            .font(.body)
                            .foregroundColor(business?.isClosed ?? false ? .red : .green)
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 5, trailing: 0))
                    }
                    .padding()
                    .hiddenNavigationBarStyle()
                }
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(business: nil, latitude: 0.0, longitude: 0.0)
    }
}


struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}


