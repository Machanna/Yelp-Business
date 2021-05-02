//
//  DetailView.swift
//  Yelp Business
//
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
                        RatingsView(rating: rating)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                        Text(business?.location?.displayAddress[0]  ?? "")
                            .font(.subheadline)
                        Text(business?.location?.displayAddress[1]  ?? "")
                            .font(.subheadline)
                        Text(business?.displayPhone ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(business?.isClosed ?? false ? "Open" : "Closed")
                            .font(.body)
                            .foregroundColor(business?.isClosed ?? false ? .green : .red)
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

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}
