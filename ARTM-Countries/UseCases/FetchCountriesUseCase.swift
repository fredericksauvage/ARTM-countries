//
//  FetchCountryUseCase.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-06.
//

import Foundation

class FetchCountriesUseCase {
    private let countryService: CountryService
    
    init(countryService: CountryService) {
        self.countryService = countryService
    }
    
    func execute(completion: @escaping (Result<[CountryDetail], Error>) -> Void) {
        countryService.fetchCountries { result in
            completion(result)
        }
    }
}
