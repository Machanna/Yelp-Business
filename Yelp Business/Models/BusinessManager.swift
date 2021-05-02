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
    
    @Published var businesses = [Business]()
    var locationManager = LocationManager()
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }

    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    private var subscriber: AnyCancellable?
        init(locationManager: LocationManager) {
            self.locationManager = locationManager
            
            // listen for available location explicitly
            subscriber = locationManager.$lastLocation
                .debounce(for: 1, scheduler: DispatchQueue.main) // wait for 5 sec to avoid often reload
                .receive(on: DispatchQueue.main)
                .sink { [weak self] location in
                    guard location != nil else { return }
                    self?.fetchDataWithSearchTerm(term: "")
                }
            
        }
    
//    func fetchData() {
//
//        let urlString = "\(yelpBusinessSearchURL)?latitude=\(userLatitude)&longitude=\(userLongitude)"
//               print(urlString)
//               performRequest(with: urlString)
//        subscriber?.cancel()
//    }
    
    func fetchDataWithSearchTerm(term: String) {
        var urlString = ""
        if term == ""{
            urlString = "\(yelpBusinessSearchURL)?latitude=\(userLatitude)&longitude=\(userLongitude)"
        }else{
            urlString = "\(yelpBusinessSearchURL)?term=\(term)&latitude=\(userLatitude)&longitude=\(userLongitude)"
        }
       
        performRequest(with: urlString)
        subscriber?.cancel()
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
