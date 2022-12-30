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
import GeoJSON


struct MapSheetView: View {
    @Environment(\.dismiss) var dismiss
    //@Binding var latValue: String
    //@Binding var lonValue: String
    
    struct Marker: Identifiable {
        let id = UUID()
        var location: MapMarker
    }

    @Binding private var lat: Double
    @Binding private var lon: Double

        private let initialLatitudinalMetres: Double = 250
        private let initialLongitudinalMetres: Double = 250

        @State private var span: MKCoordinateSpan?

        init(lat: Binding<Double>, lon: Binding<Double>) {
            _lat = lat
            _lon = lon
        }

        private var region: Binding<MKCoordinateRegion> {
            Binding {
                let centre = CLLocationCoordinate2D(latitude: lat, longitude: lon)


                if let span = span {
                    return MKCoordinateRegion(center: centre, span: span)
                } else {
                    return MKCoordinateRegion(center: centre, latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres)
                }
            } set: { region in
                lat = region.center.latitude
                lon = region.center.longitude
                span = region.span
            }
        }
    

    var body: some View {
        
        let markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), tint: .purple))]
        
        Map(coordinateRegion: region, interactionModes: [],annotationItems: markers) { marker in
            marker.location
        }
        
        VStack(alignment: .center) {
            
            Button("Close") {
                dismiss()
            }
            
            Button("Submit") {
                let npost = NostrPost(content: "{\"type\": \"Point\",\"coordinates\":[\(lat),\(lon)]}", references: [], kind: .text)
                NotificationCenter.default.post(name: .post, object: NostrPostResult.post(npost))
            }   .padding()
                .background(Color(red: 1, green: 1, blue: 1))
                .clipShape(Capsule())
            
        }
        
    }
        
}
