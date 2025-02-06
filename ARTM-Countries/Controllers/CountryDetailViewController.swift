//
//  CountryDetailViewController.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-02.
//

import Foundation
import UIKit
import Alamofire

class CountryDetailViewController: UIViewController {
    private var countryService: CountryService?
    
    private var country: CountryDetail?
    private let errorFlagTxt = "😩 An error occurred while loading the flag!"
    private let missingFlagUrlTxt = "🤔 No flag provided!"
    private var imgRequest: DataRequest?
    
    private let name = UILabel()
    private let flag: UIImageView = {
        let image = UIImageView()
        image.isHidden = true
        return image
    }()
    private let flagLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.startAnimating()
        return indicator
    }()
    private let flagError: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    private let continent = UILabel()
    private let population = UILabel()
    private let capitale = UILabel()
    
    init(country: CountryDetail?, countryService: CountryService?)
    {
        super.init(nibName: nil, bundle: nil)
        self.country = country
        self.countryService = countryService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        buildView()
        loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imgRequest?.cancel()
    }
    private func buildView() {
        view.backgroundColor = .white
        
        view.addSubview(name)
        fullWidthConstraint(to: name, horizontalPadding: 0)
        name.numberOfLines = 0
        name.font = UIFont.boldSystemFont(ofSize: 20.0)
        name.textAlignment = .center
        
        view.addSubview(flag)
        flag.contentMode = .scaleAspectFit
        fullWidthConstraint(to: flag, after: name, horizontalPadding: 0)
        flag.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(flagLoadingIndicator)
        flagLoadingIndicator.contentMode = .scaleAspectFit
        flagLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        flagLoadingIndicator.centerYAnchor.constraint(equalTo: flag.centerYAnchor).isActive = true
        flagLoadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        flagLoadingIndicator.widthAnchor.constraint(equalToConstant: 200).isActive = true
        flagLoadingIndicator.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(flagError)
        flagError.translatesAutoresizingMaskIntoConstraints = false
        flagError.textAlignment = .center
        flagError.centerYAnchor.constraint(equalTo: flag.centerYAnchor).isActive = true
        flagError.centerXAnchor.constraint(equalTo: flag.centerXAnchor).isActive = true
        flagError.widthAnchor.constraint(equalTo: flag.widthAnchor).isActive = true
        flagError.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(continent)
        fullWidthConstraint(to: continent, after: flag)
        continent.numberOfLines = 0
        continent.font = UIFont.systemFont(ofSize: 15.0)
        continent.textAlignment = .natural
        continent.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(population)
        fullWidthConstraint(to: population, after: continent)
        population.numberOfLines = 0
        population.font = UIFont.systemFont(ofSize: 15.0)
        population.textAlignment = .natural
        population.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(capitale)
        fullWidthConstraint(to: capitale, after: population)
        capitale.numberOfLines = 0
        capitale.font = UIFont.systemFont(ofSize: 15.0)
        capitale.textAlignment = .natural
        capitale.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func fullWidthConstraint(to: UIView, after: UIView? = nil, horizontalPadding: CGFloat = 10) {
        if let after = after {
            to.topAnchor.constraint(equalTo: after.bottomAnchor, constant: 10).isActive = true
        } else {
            to.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        to.translatesAutoresizingMaskIntoConstraints = false
        to.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        to.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * horizontalPadding).isActive = true
    }
    
    private func loadData() {
        name.text = country?.name?.common
        name.sizeToFit()
        continent.text = "Continent(s): " + (country?.continents?.compactMap { $0 }.joined(separator: ", ") ?? "")
        population.text = "Pouplation: \(country?.population ?? 0)"
        capitale.text = "Capitale(s): " + (country?.capital?.compactMap { $0 }.joined(separator: ", ") ?? "")
        
        showFlagLoading()
        
        guard let pngUrl = country?.flags?.png else {
            showFlagError(text: missingFlagUrlTxt)
            return
        }
        guard let countryService = countryService else { return }
        imgRequest = countryService.fetchCountryFlag(for: pngUrl) { [weak self] response in
            MainActor.assumeIsolated {
                guard let this = self else { return }
                switch response.result {
                case .success(let image):
                    this.showFlagImage(image: image)
                case .failure:
                    this.showFlagError(text: this.errorFlagTxt)
                }
            }
        }
    }
    
    private func showFlagError(text: String) {
        flagError.text = text
        flag.isHidden = true
        flagError.isHidden = false
        flagLoadingIndicator.stopAnimating()
    }
    
    private func showFlagImage(image: UIImage) {
        flag.image = image
        flag.isHidden = false
        flagError.isHidden = true
        flagLoadingIndicator.stopAnimating()
    }
    
    private func showFlagLoading() {
        flagLoadingIndicator.startAnimating()
    }
}
