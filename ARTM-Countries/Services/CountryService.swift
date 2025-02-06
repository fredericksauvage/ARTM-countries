//
//  CountryService.swift
//  ARTM-Countries
//
//  Created by frederick sauvage on 2025-02-02.
//

import Foundation
import Alamofire
import AlamofireImage
import Dip

protocol CountryService {
    func fetchCountries(completionHandler: @escaping  @Sendable (Result<[CountryDetail], Error>) -> Void) -> DataRequest?
    func fetchCountryFlag(for url: String, completionHandler: @escaping  @Sendable (AFDataResponse<UIImage>)  -> Void) -> DataRequest
}
enum CountryError: Error {
    case invalidResponse
    case invalidUrlService
}
class CountryServiceImpl:
    CountryService {
    var urlService: UrlService?
    
    init(urlService: UrlService?) {
        self.urlService = urlService
    }
    
    func fetchCountries(completionHandler: @escaping @Sendable (Result<[CountryDetail], Error>) -> Void) -> DataRequest? {
        guard let urlService = urlService else {
            completionHandler(.failure(CountryError.invalidUrlService))
            return nil
        }
        return AF.request(urlService.getCountriesApiUrl(version: "3.1")).responseDecodable(of: [CountryDetail].self) { response in
            switch response.result {
            case .success(let countries):
                completionHandler(.success(countries))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
    }
    
    func fetchCountryFlag(for url: String, completionHandler: @escaping @Sendable  (AFDataResponse<UIImage>)  -> Void) -> DataRequest {
        return AF.request(url).responseImage { response in
            completionHandler(response)
        }
    }
}
