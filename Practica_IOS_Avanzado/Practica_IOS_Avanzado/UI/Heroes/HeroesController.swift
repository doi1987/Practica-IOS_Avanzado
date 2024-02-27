//
//  HeroesController.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import UIKit
import Kingfisher


//Controller donde mostraremos el listado de Heroes
class HeroesController: UIViewController {
	
	@IBOutlet weak var sampleHero: UIImageView!
	
	private var secureData: SecureDataProtocol
	
	init(secureData: SecureDataProtocol = SecureDataKeychain()) {
		self.secureData = secureData
		super.init(nibName: String(describing: HeroesController.self), bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		//Ocultamso el navigation bar porque no queremos tener opción de navegar Back
		navigationController?.isNavigationBarHidden = true
		
		//Ejemplo de como usar KingFisher para descarga de imágenes, cacheo y añadir transiciones
		//LA cache la gestiona la librería por defecto
		sampleHero.kf.setImage(with: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"), options: [.transition(.fade(1))])

		// Do any additional setup after loading the view.
	}

	@IBAction func logoutTapped(_ sender: Any) {
		//Cuando pulsamos logout, borraremos base de datos y token
		// estas acciones y todo lo relacionado con manipulación de datos
		// debe hacerse en el viewModel. Aquñi solo está con propósito de ejemplo
		// la navegación a RootViewController  nos lleva al primer controller de la jerarquía (Splash)
		// El Splash aplicará la lógica para mostrar la sigueinte pantalla
		secureData.deleteToken()
		
		//LAnavegación si es responsabilidad del controller
		navigationController?.popToRootViewController(animated: true)
	}
	
	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

	@IBAction func DetailTapped(_ sender: Any) {
		
		//Simula la selleción de una celda de un héroe
		let hero = Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", description: "", photo: "", favorite: true)
		let viewModel = DetailHeroViewModel(hero: hero)
		let detailHeroVC = HeroDetailController(viewModel: viewModel)
		navigationController?.pushViewController(detailHeroVC, animated: true)
	}
}
