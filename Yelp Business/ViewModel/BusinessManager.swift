//
//  BusinessManager.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/1/21.
//

import Foundation
import CoreLocation
import Combine

class BusinessManager : ObservableObject{
    
    let yelpBusinessSearchURL = "https://api.yelp.com/v3/businesses/search"
    
    @Published var loading = true
    @Published var businesses = [Business]()
    
    var locationManager = LocationManager()
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    /**
     function to subscribe to the LocationManager class to get notified when location retrieval is successful.
     **/
    private var subscriber: AnyCancellable?
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        // listen for available location explicitly
        subscriber = locationManager.$lastLocation
            .debounce(for: 1, scheduler: DispatchQueue.main) // waiting for a sec to avoid often reload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                /**
                 1. if location permission is denied or if location is nil,
                 making the yelp search api web service call with zero coordinate.
                 2. if location is  not nil,
                 making the yelp search api web service call with user's current location.
                 **/
                self?.fetchDataWithSearchTerm(term: "")
            }
        
    }
    
    /*
     function to make the yelp search api web service call with user's current location and search term.
     */
    func fetchDataWithSearchTerm(term: String) {
        var urlString = ""
        if term == ""{
            urlString = "\(yelpBusinessSearchURL)?latitude=\(userLatitude)&longitude=\(userLongitude)"
        }else{
            urlString = "\(yelpBusinessSearchURL)?term=\(term)&latitude=\(userLatitude)&longitude=\(userLongitude)"
        }
        
        performRequest(with: urlString)
        
        /*
          Cancelling the subscription when latitude and longitude are not zero.
         */
        if userLatitude != 0 && userLongitude != 0{
            subscriber?.cancel()
        }
    }
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.setValue("Bearer Hh--9T9b5XAtkSjHa512eworo1jGIXkrmT-OBrn0dauXpjpIrxWbndYbzWqBksE81C7F9123Lp6cJubdqAFWQ3s8SolYxqBhAAsZbRphSLUviAjJJY9BGdp6FKGMYHYx", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with:request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do{
                        let results = try decoder.decode(Results.self, from: safeData)
                        DispatchQueue.main.async {
                            self.businesses = results.businesses
                            self.loading = false
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}
