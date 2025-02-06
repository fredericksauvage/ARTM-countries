//
//  UrlService.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-05.
//

import Foundation

protocol UrlService {
    func getCountriesApiUrl(version: String) -> String
}

class UrlServiceImpl: UrlService {
    func getCountriesApiUrl(version: String) -> String {
        return "https://restcountries.com/v\(version)/all"
    }
}
