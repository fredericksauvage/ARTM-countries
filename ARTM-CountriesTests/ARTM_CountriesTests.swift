//
//  ARTM_CountriesTests.swift
//  ARTM-CountriesTests
//
//  Created by frederick sauvage on 2025-02-02.
//

import XCTest
@testable import ARTM_Countries
import Dip

final class ARTM_CountriesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUrlService() throws {
        guard let urlService: UrlService = try? AppContainer.shared.resolve() else { return }
        let url = urlService.getCountriesApiUrl(version: "4.3")
        XCTAssertEqual(url, "https://restcountries.com/v4.3/all", "Url generation error")
    }
}

