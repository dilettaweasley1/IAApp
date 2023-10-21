import SwiftUI
import RealityKit
import CoreLocation
import ARKit

class ARViewController: UIViewController, CLLocationManagerDelegate {
    private let arView = ARView(frame: .zero)
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up ARView
        arView.frame = view.bounds
        view.addSubview(arView)

        // Set up CoreLocation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Define the desired coordinates and distance threshold
            let montaditos = (latitude: 39.4629062, longitude: -0.3714228, altitude: 0, color: UIColor.red)
            let ubicafe = (latitude: 39.4604514, longitude: -0.3738470, altitude: 0, color: UIColor.green)
            let abanicos = (latitude: 39.4647138, longitude: -0.3755119, altitude: 0, color: UIColor.blue)
            let casa = (latitude: 39.4632614, longitude: -0.3731362, altitude: 0, color: UIColor.yellow)
            
            for locationInfo in [montaditos, ubicafe, abanicos, casa] {
                let latitude = locationInfo.latitude
                let longitude = locationInfo.longitude
                let altitude = locationInfo.altitude
                let color = locationInfo.color

                // Define the distance threshold
                let distanceThreshold: CLLocationDistance = 50

                // Calculate the distance
                let distance = location.distance(from: CLLocation(latitude: latitude, longitude: longitude))

                // Check if the user is within the distance threshold
                if distance <= distanceThreshold {
                    let sphere = MeshResource.generateSphere(radius: 0.5)
                    let sphereModel = ModelEntity(mesh: sphere, materials: [SimpleMaterial(color: color, isMetallic: false)])

                    let translation = SIMD3<Float>(
                        Float(longitude),
                        Float(altitude),
                        -Float(latitude)
                    )
                    let transform = Transform(translation: translation)

                    let sphereAnchor = AnchorEntity(.world(transform: transform.matrix))
                    sphereAnchor.addChild(sphereModel)

                    arView.scene.addAnchor(sphereAnchor)
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        Container()
    }

    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> ARViewController {
            return ARViewController()
        }

        func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
            // Update UI here if needed
        }
    }
}

