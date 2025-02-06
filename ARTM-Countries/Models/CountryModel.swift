//
//  File.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-02.
//

import Foundation

// MARK: - CountryDetail
struct CountryDetail: Codable {
    var name: CountryName?
    var flags: CountryFlags?
    var population: Int?
    var continents: [String?]?
    var capital: [String?]?
}

// MARK: - CountryNames
struct CountryName: Codable {
    var common, official: String?
}

// MARK: - CountryFlags
struct CountryFlags: Codable {
    var png, svg: String?
}
