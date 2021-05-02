//
//  DetailView.swift
//  Yelp Business
//
//  Created by Shravya Machanna on 5/1/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let business: Business?
    let latitude: Double
    let longitude: Double
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
      }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return calculateRouteAndDirection(mapView)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func calculateRouteAndDirection(_ mapView: MKMapView) -> MKMapView{
        let source = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        if let lat = business?.coordinates.latitude, let lon = business?.coordinates.longitude {
            let annotations = MKPointAnnotation()
            annotations.title = business?.name
            annotations.subtitle = business?.phone
            annotations.coordinate = CLLocationCoordinate2D(latitude:
                                                                lat, longitude: lon)
            let destination = MKPlacemark(coordinate: annotations.coordinate)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: source)
            request.destination = MKMapItem(placemark: destination)
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
              directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotation(annotations)
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                  route.polyline.boundingMapRect,
                  edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                  animated: true)
              }
            
        }
        return mapView
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(business: nil, latitude: 0.0, longitude: 0.0)
    }
}


