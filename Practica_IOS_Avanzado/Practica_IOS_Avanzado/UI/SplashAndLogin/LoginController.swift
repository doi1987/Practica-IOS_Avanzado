//
//  LoginController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit

class LoginController: UIViewController {
	
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	private let viewModel: LoginViewModel
	
	init(viewModel: LoginViewModel = LoginViewModel()) {
		self.viewModel = viewModel
		super.init(nibName: String(describing: LoginController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Ocultamso el navigation bar porque no queremos tener opción de navegar Back
		navigationController?.isNavigationBarHidden = true
		viewModel.loginStateChanged = { state in
			//TODO: - Controlar que puede fallar el servicio (Se puede pasar un parámetro estado por ejemplo en loginStateChanged
			switch state {
			case .success:
				self.activityIndicator.stopAnimating()
				// Navegamos a Heroes Controller
				DispatchQueue.main.async {
					// Si el login es con exito, navegamos a la pantalal de Heroes
					let heroes = HeroesController()
					self.navigationController?.pushViewController(heroes, animated: true)
				}
			case .failed:
				self.activityIndicator.stopAnimating()
			case .loading:
				self.activityIndicator.startAnimating()
			}
		}

	}

	@IBAction func loginTapped(_ sender: Any) {
		viewModel.loginWith(email: "davidortegaiglesias@gmail.es", password: "abcdef")
	}
	
	
	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}

