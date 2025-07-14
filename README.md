Multi-Polygon GeoFence iOS Map App
This iOS application demonstrates how to display and interact with multiple geofence polygons on a MKMapView using Swift and UIKit.

Features
✅ Display Multiple Polygons: Visualize multiple geo-fence areas on a map using polygon overlays.

✅ Tap Interaction: Detects tap inside any polygon and zooms into it.

✅ Auto-Zoom to All Polygons: Automatically zooms the map to fit all polygons on view load.

✅ Clean UI: Uses standard MapKit with red-colored polygons and smooth animations.

✅ Reusable Logic: Clean and modular code to easily extend and add more polygons.

How It Works
The app reads an array of coordinates (latitude and longitude pairs) representing multiple polygons.

All polygons are added to the map as overlays.

On launch, the map automatically zooms to show all polygons with padding.

When the user taps inside any polygon, the map zooms into that specific polygon.

File Structure
css
Copy
Edit
├── ViewController.swift
├── Main.storyboard
└── README.md
Code Overview
Polygons Source
swift
Copy
Edit
let multipleGeoFences: [[[String: Double]]] = [
    [ // Polygon 1 coordinates ],
    [ // Polygon 2 coordinates ]
]
Main Logic
addPolygons() — Adds multiple polygons to the map.

zoomToFit() — Zooms map to fit all polygons with padding.

handleMapTap() — Detects tap inside a polygon and zooms in.

rendererFor overlay — Renders polygons with stroke and fill color.

How to Use
Clone or download this repository.

Open the project in Xcode.

Connect the mapView IBOutlet in the storyboard.

Run the app on a simulator or device.

Dependencies
UIKit

MapKit (built-in)

Screenshots
Full View with All Polygons	Zoomed-in Polygon View
	

Customization
To add more polygons, simply update the multipleGeoFences array with new coordinates.

To change polygon colors, modify the rendererFor overlay function.

License
MIT License — Free to use for personal and commercial projects.
