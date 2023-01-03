//
//  MapSheetView.swift
//  damus
//
//  Created by Miles Bates on 12/30/22.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit



struct MapSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    struct Marker: Identifiable {
        let id = UUID()
        var location: MapMarker
    }
    
    @Binding private var lat: Double
    @Binding private var lon: Double
    
    private let initialLatitudinalMeters: Double = 250
    private let initialLongitudinalMeters: Double = 250
    
    @State private var span: MKCoordinateSpan?
    
    init(lat: Binding<Double>, lon: Binding<Double>) {
        _lat = lat
        _lon = lon
    }
    

    
    private var region: Binding<MKCoordinateRegion> {
        Binding {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            
            if let span = span {
                return MKCoordinateRegion(center: center, span: span)
            } else {
                return MKCoordinateRegion(center: center, latitudinalMeters: initialLatitudinalMeters, longitudinalMeters: initialLongitudinalMeters)
            }
        } set: { region in
            lat = region.center.latitude
            lon = region.center.longitude
            span = region.span
        }
    }
    
    var geojson_content: String {
        return "{\"type\": \"Point\",\"coordinates\":[\(lat),\(lon)]}"
    }
    
    var body: some View {
        
        let markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), tint: .purple))]
        
        Map(coordinateRegion: region, interactionModes: [],annotationItems: markers) { marker in
            marker.location
        }
        
        VStack(alignment: .center) {
                        
            Button("Submit") {
                let npost = NostrPost(content: geojson_content, references: [], kind: .text)
                NotificationCenter.default.post(name: .post, object: NostrPostResult.post(npost))
                dismiss()
            }   .padding()
            
            Button("Cancel") {
                dismiss()
            }
            
        }
        
    }
    
}
