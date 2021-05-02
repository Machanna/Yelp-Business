//
//  ContentView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var businessManager : BusinessManager
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    init() {
        let location = LocationManager()
        self.locationManager = location
        self.businessManager = BusinessManager(locationManager: location)
        
        self.locationManager.startUpdating()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            self.fetchSearchData()
                            print("onCommit")
                        }).foregroundColor(.primary)
                        .keyboardType(.webSearch)
                        
                        Button(action: {
                            self.searchText = ""
                            self.fetchSearchData()
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                            self.fetchSearchData()
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton)
                List(businessManager.businesses) { business in
                    NavigationLink(destination: DetailView(business: business, latitude: businessManager.userLatitude, longitude: businessManager.userLongitude)) {
                        HStack(alignment:.top) {
                            ImageView(withURL: business.imageURL)
                            VStack(alignment: .leading){
                                Text(business.name)
                                RatingsView(rating: Float(business.rating))
                                //CategoriesView(business: business)
                                Text(String(format: "%.2f", business.distance/1000.0) + " mi")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                }
            }.navigationBarTitle("Yelp Businesses")
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
