//
//  SplashViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit

// Pantalla que aplica la lógica para mostrar la pantalla de login o Heroes

class SplashViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var splashActivityIndicator: UIActivityIndicatorView!
	
	private var secureData: SecureDataProtocol
	
	// MARK: - Inits
	init(secureData: SecureDataProtocol = SecureDataKeychain()) {
		self.secureData = secureData
		super.init(nibName: String(describing: SplashViewController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		// Si no tenemos token mostramos el login , Heroes en otro caso
		var destination: UIViewController
		if let _ = secureData.getToken() {
			destination = HeroesController()
		} else {
			destination = LoginController()
		}
		navigationController?.pushViewController(destination, animated: true)
	}


}

