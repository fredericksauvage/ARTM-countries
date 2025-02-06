//
//  CountriesViewModel.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-06.
//

import Foundation

class CountriesViewModel {
    private let fetchCountriesUseCase: FetchCountriesUseCase
    
    var countries: [CountryDetail] = []
    var onDataUpdate: (([CountryDetail]) -> Void)?
    var onError: ((String) -> Void)?
    
    init(fetchCountriesUseCase: FetchCountriesUseCase) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
    }
    
    func fetchCountries() {
        fetchCountriesUseCase.execute { [weak self] result in
            switch result {
            case .success(let countries):
                self?.countries = countries
                self?.onDataUpdate?(countries)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
