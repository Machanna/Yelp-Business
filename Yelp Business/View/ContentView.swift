//
//  ContentView.swift
//  Yelp Business
//  Initial View to search and display yelp business.
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var businessManager : BusinessManager
    @State private var searchText = ""
    
    
    init() {
        let location = LocationManager()
        self.locationManager = location
        self.businessManager = BusinessManager(locationManager: location)
        self.locationManager.startUpdating()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText, searchAction: {self.fetchSearchData()})
                LoadingView(isShowing: $businessManager.loading) {
                    Group {
                        if businessManager.businesses.isEmpty {
                           EmptyView()
                        }else{
                            List(businessManager.businesses) { business in
                                NavigationLink(destination: DetailView(business: business, latitude: businessManager.userLatitude, longitude: businessManager.userLongitude)) {
                                    HStack(alignment:.top) {
                                        ImageView(withURL: business.imageURL)
                                        VStack(alignment: .leading){
                                            Text(business.name)
                                            RatingsView(rating: Float(business.rating), reviewCount: business.reviewCount)
                                            CategoriesView(categories: business.categories)
                                            Text(String(format: "%.2f", business.distance/1000.0) + " mi")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle("Yelp Business")
            .resignKeyboardOnDragGesture()
        }
    }
    
    func fetchSearchData(){
        self.businessManager.fetchDataWithSearchTerm(term: searchText)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
