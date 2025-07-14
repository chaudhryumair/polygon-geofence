//
//  ViewController.swift
//  testtt
//
//  Created by Chaudhry Umair on 20/05/2025.
//

import UIKit
import MapKit



class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    // MARK: - Variables
    
    let multipleGeoFences: [[[String: Double]]] = [
        
        [
            ["Lat": 47.007270052079825, "lng": -123.59374523162843],
            ["Lat": 47.00723347180272, "lng": -123.58253359794617],
            ["Lat": 46.99494108039157, "lng": -123.58430385589601],
            ["Lat": 46.99135526681573, "lng": -123.58430385589601],
            ["Lat": 46.99128208444165, "lng": -123.60908746719362],
            ["Lat": 46.99962422965204, "lng": -123.60324025154115],
            
        ],
        
        [
            ["Lat": 46.979542334504686, "lng": -123.59834253787996],
            ["Lat": 46.97946913595677, "lng": -123.60019326210023],
            ["Lat": 46.9784992457366, "lng": -123.60016644001009],
            ["Lat": 46.97857244561228, "lng": -123.59828889369966],
            
        ],
        
     
    ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapviewSetup()
    }
    // MARK: - Utility Functions
    
    func mapviewSetup(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        mapView.mapType = .standard
        mapView.delegate = self
        // Center and zoom to an approximate area before adding polygons
        let center = CLLocationCoordinate2D(latitude: 34.23, longitude: -118.885)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(region, animated: false)
        
        // Add polygons overlays to map
        addPolygons(from: multipleGeoFences)
        
        // Zoom map to fit all polygons neatly with padding
        zoomToFit(polygons: multipleGeoFences)
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        for overlay in mapView.overlays {
            if let polygon = overlay as? MKPolygon {
                let renderer = mapView.renderer(for: polygon) as? MKPolygonRenderer
                let mapPoint = MKMapPoint(coordinate)
                let point = renderer?.point(for: mapPoint)
                
                if let point = point, renderer?.path.contains(point) == true {
                    let rect = polygon.boundingMapRect
                    let insets = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40)
                    mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
                    break
                }
            }
        }
    }
    
    // Converts array of dictionaries to array of CLLocationCoordinate2D
    private func coordinates(from geoFence: [[String: Double]]) -> [CLLocationCoordinate2D] {
        return geoFence.compactMap { dict in
            if let lat = dict["Lat"], let lng = dict["lng"] {
                return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            return nil
        }
    }
    
    // Adds MKPolygon overlays for each polygon in the array
    private func addPolygons(from geoFences: [[[String: Double]]]) {
        for geoFence in geoFences {
            let coords = coordinates(from: geoFence)
            guard coords.count > 2 else { continue }
            var mutableCoords = coords
            let polygon = MKPolygon(coordinates: &mutableCoords, count: mutableCoords.count)
            mapView.addOverlay(polygon)
        }
    }
    
    // Zooms map view to fit all polygons with padding
    private func zoomToFit(polygons: [[[String: Double]]]) {
        var overallRect = MKMapRect.null
        
        for geoFence in polygons {
            let coords = coordinates(from: geoFence)
            var mutableCoords = coords
            let polygon = MKPolygon(coordinates: &mutableCoords, count: mutableCoords.count)
            let rect = polygon.boundingMapRect
            overallRect = overallRect.isNull ? rect : overallRect.union(rect)
        }
        
        // Padding around polygons (in points)
        let edgeInsets = UIEdgeInsets(top: 80, left: 40, bottom: 80, right: 40)
        mapView.setVisibleMapRect(overallRect, edgePadding: edgeInsets, animated: true)
    }
}
    // MARK: - MKMapViewDelegate

extension ViewController:MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.1)
                renderer.strokeColor = UIColor.red
                renderer.lineWidth = 3

                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, didSelect overlay: MKOverlay) {
            guard let polygon = overlay as? MKPolygon else { return }
            
            let rect = polygon.boundingMapRect
            let insets = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40)
            mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
        }
        
    }

   

