//
//  HomeViewController.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-02.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    private let buttonTitle = "Liste des pays"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }
    
    private func buildView() {
        view.backgroundColor = .white
        
        let flagImage = UIImageView(image: UIImage(named: "Flag"))
        view.addSubview(flagImage)
        flagImage.contentMode = .scaleAspectFit
        flagImage.translatesAutoresizingMaskIntoConstraints = false
        flagImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        flagImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        flagImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        flagImage.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
        let countriesListButton = UIButton()
        view.addSubview(countriesListButton)
        countriesListButton.backgroundColor = .clear
        countriesListButton.layer.cornerRadius = 5
        countriesListButton.layer.borderWidth = 1
        countriesListButton.layer.borderColor = UIColor.black.cgColor
        countriesListButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        countriesListButton.setTitle(" \(buttonTitle) ", for: .normal)
        countriesListButton.setTitleColor(.black, for: .normal)
        countriesListButton.setTitleColor(.gray, for: .highlighted)
        countriesListButton.sizeToFit()
        countriesListButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        countriesListButton.translatesAutoresizingMaskIntoConstraints = false
        countriesListButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        countriesListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func buttonPressed() {
        navigationController?.pushViewController(CountriesListViewController(countryService: try?  AppContainer.shared.resolve()), animated: true)
    }
}

