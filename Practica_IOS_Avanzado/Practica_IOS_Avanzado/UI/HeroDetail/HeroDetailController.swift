//
//  HeroDetailController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit
import MapKit
import CoreLocation

class HeroDetailController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	private let viewModel: DetailHeroViewModel
	
	private let locationManager = CLLocationManager()
	
	init(viewModel: DetailHeroViewModel) {
		self.viewModel = viewModel
		super.init(nibName: String(describing:HeroDetailController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureUI() {
		mapView.delegate = self
		mapView.showsUserTrackingButton = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		checkLocationAuthorizationStatus()
		addObservers()
		viewModel.loadData()
	}
	
	@IBAction func btnBackTapped(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	
	@IBAction func backTapped(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	private func addObservers() {
		viewModel.stateChanged = { [weak self] state in
			switch state {
			case .updated:
				self?.updateDataInterface()
			}
		}
	}
	
	private func updateDataInterface() {
		addAnnotations()
		
		//CCentra el mapa en la primera annotation
		if let annotation = mapView.annotations.first {
			let region = MKCoordinateRegion(center: annotation.coordinate, 
											latitudinalMeters: 100000,
											longitudinalMeters: 100000)
			mapView.region = region
		}
	}
	
	
	//Crea las annotations  a partir de las locations del Heroe
	private func addAnnotations() {
		var annotations = [HeroAnnotation]()
		let (name, id) = viewModel.heroNameAndId()
		for location in viewModel.locationsHero() {
			annotations.append(
				HeroAnnotation.init(coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0,
													  longitude: Double(location.longitude ?? "") ?? 0.0),
									title: name,
									id: id,
									date: location.date)
			)
		}
		//Añade las annotations al mapa
		mapView.addAnnotations(annotations)
	}
	
	func checkLocationAuthorizationStatus() {
		
		let status = locationManager.authorizationStatus
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .denied, .restricted:
			mapView.showsUserLocation = false
		case .authorizedAlways, .authorizedWhenInUse:
			mapView.showsUserLocation = true
			locationManager.startUpdatingLocation()
		@unknown default:
			break
		}
	}

}


extension HeroDetailController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
		guard let heroAnnotation = annotation as? HeroAnnotation else {
			return
		}
		debugPrint("Annotation selected of hero \(heroAnnotation.title ?? "")")
		debugPrint("Located on  \(heroAnnotation.date ?? "")")
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		// solo  queremos custom vire para las annotations del dheroe, la ubicación del usuario por ejemplo
		// se mostrará con el punto azul por defecto
		guard let _ = annotation as? HeroAnnotation else {
			return nil
		}

		// si no hay annotationView que reutilizar creamos una nueva
		if let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.reuseIdentifier) {
			return annotation
		}
		return HeroAnnotationView.init(annotation: annotation, reuseIdentifier: HeroAnnotationView.reuseIdentifier)
	}
}
