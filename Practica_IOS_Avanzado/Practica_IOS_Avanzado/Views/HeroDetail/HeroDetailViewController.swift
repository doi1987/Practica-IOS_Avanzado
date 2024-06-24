//
//  HeroDetailViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import UIKit
import MapKit
import CoreLocation

class HeroDetailViewController: UIViewController {
	// MARK: - Outlets
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var heroName: UILabel!	
	@IBOutlet weak var heroDescription: UITextView!
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var transformationCollectionView: UICollectionView!
	
	// MARK: - Properties -
	private let heroDetailViewModel: HeroDetailViewModel
	private let locationManager = CLLocationManager()
	
	init(heroDetailViewModel: HeroDetailViewModel) {
		self.heroDetailViewModel = heroDetailViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureUI() {
		transformationCollectionView.register(UINib(nibName: TransformationCollectionViewCell.nibName,
													bundle: nil), forCellWithReuseIdentifier: TransformationCollectionViewCell.identifier)
		transformationCollectionView.dataSource = self
		transformationCollectionView.delegate = self
		mapView.delegate = self
		mapView.showsUserLocation = true
		mapView.showsUserTrackingButton = true
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setObservers()
		configureUI()
		checkLocationAuthorizationStatus()
		heroDetailViewModel.loadDetail()
	}
}

private extension HeroDetailViewController {
	func setObservers(){
		heroDetailViewModel.heroDetailStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				self?.loadingView.isHidden = false
			case .loaded:
				self?.loadingView.isHidden = true
				self?.setupView()
			case .error(_):
				self?.loadingView.isHidden = true
			case .none:
				print("Hero Detail None")
			}
		}
	}
	
	func setupView() {
		heroName.text = heroDetailViewModel.getHero()?.name
		heroDescription.text = heroDetailViewModel.getHero()?.description
		transformationCollectionView.reloadData()
		updateDataInterface()
	}
	
	func updateDataInterface() {
		addAnnotations()
		//Centra el mapa en la primera annotation
		if let annotation = mapView.annotations.first {
			let region = MKCoordinateRegion(center: annotation.coordinate, 
											latitudinalMeters: 100000,
											longitudinalMeters: 100000)
			mapView.region = region
		}
	}
	
	//Crea las annotations  a partir de las locations del Heroe
	func addAnnotations() {
		var annotations = [HeroAnnotation]()
		let (name, id) = heroDetailViewModel.heroNameAndId()
		for location in heroDetailViewModel.locationsHero() {
			let date: Date = DateFormatter.formatDate.date(from: location.date ?? "") ?? .now
			annotations.append(	
				HeroAnnotation(coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0,
													  longitude: Double(location.longitude ?? "") ?? 0.0),
									title: name,
									id: id,
									subtitle: date.toDayMonthYear())
			)
		}
		//Añade las annotations al mapa
			self.mapView.addAnnotations(annotations)		
	}
	
	func checkLocationAuthorizationStatus() {
		let status = locationManager.authorizationStatus
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .denied, .restricted:
			mapView.showsUserLocation = false
			mapView.showsUserTrackingButton = false
		case .authorizedAlways, .authorizedWhenInUse:
			mapView.showsUserLocation = true
			mapView.showsUserTrackingButton = true
			locationManager.startUpdatingLocation()
		@unknown default:
			break
		}
	}
}

extension HeroDetailViewController: UICollectionViewDataSource,
									UICollectionViewDelegate,
									UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, 
						numberOfItemsInSection section: Int) -> Int {
		return heroDetailViewModel.getTransformations().count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCollectionViewCell.identifier,
													  for: indexPath) as! TransformationCollectionViewCell
		cell.configure(transformationModel: heroDetailViewModel.getTransformations()[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let transformation = heroDetailViewModel.getTransformations()[indexPath.row]
		let viewModel = TransformationDetailViewModel(transformationDetail: transformation)
		let detailvc = TransformationDetailViewController(transformationDetailViewModel: viewModel)
		
		navigationController?.present(detailvc, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: collectionView.bounds.size.width / 3, height: collectionView.bounds.size.height)
	}
}


extension HeroDetailViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, 
				 didSelect annotation: MKAnnotation) {
		guard let heroAnnotation = annotation as? HeroAnnotation else {
			return
		}
		debugPrint("Annotation selected of hero \(heroAnnotation.title ?? "")")
		debugPrint("Located on  \(heroAnnotation.subtitle ?? "")")
	}
	
	func mapView(_ mapView: MKMapView, 
				 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		// solo  queremos custom view para las annotations del dheroe, la ubicación del usuario por ejemplo
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
