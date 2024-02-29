//
//  LoginController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit

class LoginController: UIViewController {
	
	// MARK: - Outlets
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var errorEmail: UILabel!	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorPassword: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	private let viewModel: LoginViewModel
	
	// MARK: - Inits
	init(viewModel: LoginViewModel = LoginViewModel()) {
		self.viewModel = viewModel
		super.init(nibName: String(describing: LoginController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Ocultamos el navigation bar porque no queremos tener opción de navegar Back
		navigationController?.isNavigationBarHidden = true
		emailTextField.addTarget(self, action: #selector(validEmail(_:)), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(validPassword(_:)), for: .editingChanged)
		viewModel.loginStateChanged = { [weak self] state in
			//TODO: - Controlar que puede fallar el servicio (Se puede pasar un parámetro estado por ejemplo en loginStateChanged
			switch state {
			case .loaded:
				self?.activityIndicator.stopAnimating()
				// Navegamos a Heroes Controller
				DispatchQueue.main.async {
					// Si el login es con exito, navegamos a la pantalla de Heroes
					let heroes = HeroesController()
					self?.navigationController?.pushViewController(heroes, animated: true)
				}
			case .errorNetwork(_):
				self?.activityIndicator.stopAnimating()
			case .loading:
				self?.activityIndicator.startAnimating()
			case .showErrorEmail(let error):
				self?.errorEmail.text = error
				self?.errorEmail.isHidden = (error == nil || error?.isEmpty == true)
			case .showErrorPassword(let error):
				self?.errorPassword.text = error
				self?.errorPassword.isHidden = (error == nil || error?.isEmpty == true) 
			}
		}
	}		
	
	// MARK: - Actions
	@IBAction func loginTapped(_ sender: Any) {
		viewModel.loginWith(email: "davidortegaiglesias@gmail.com", password: "abcdef")
		//		viewModel.loginWith(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
	}
	
	
	
	@objc func validEmail(_ sender: UITextField) {
		guard let text = sender.text else { return }
		
		errorEmail.isHidden = viewModel.isValid(email: text)
	}
	
	@objc func validPassword(_ sender: UITextField) {
		guard let text = sender.text else { return }
		
		errorPassword.isHidden = viewModel.isValid(password: text)
	}
}
