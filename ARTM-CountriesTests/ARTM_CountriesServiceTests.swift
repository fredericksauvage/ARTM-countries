import XCTest
import Alamofire
@testable import ARTM_Countries

// Mock URLSession pour simuler les appels réseau
class MockUrlSession: URLProtocol {
    static var testData: Data?
    static var testResponse: HTTPURLResponse?
    static var testError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockUrlSession.testError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self, didReceive: MockUrlSession.testResponse!, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: MockUrlSession.testData ?? Data())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

// Test Case pour CountryServiceImpl
class CountryServiceTests: XCTestCase {
    var countryService: CountryServiceImpl!
    var session: Session!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlSession.self]
        session = Session(configuration: config)
        countryService = CountryServiceImpl()
    }
    
    func testGetCountries_Success() {
        let jsonResponse = """
        [
            {"name": {"common": "France"}, "cca2": "FR"},
            {"name": {"common": "Canada"}, "cca2": "CA"}
        ]
        """.data(using: .utf8)!
        
        MockUrlSession.testData = jsonResponse
        MockUrlSession.testResponse = HTTPURLResponse(url: URL(string: "https://restcountries.com/v3.1/all")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "Get Countries")
        
        _ = countryService.getCountries { response in
            switch response.result {
            case .success(let countries):
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name?.common, "France")
            case .failure:
                XCTFail("Test failed: Expected success but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCountries_Failure() {
        MockUrlSession.testError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        
        let expectation = self.expectation(description: "Get Countries Failure")
        
        countryService.getCountries { response in
            switch response.result {
            case .success:
                XCTFail("Test failed: Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

// Test Case pour UrlServiceImpl
class UrlServiceTests: XCTestCase {
    func testGetCountriesURL() {
        let urlService = UrlServiceImpl()
        let expectedURL = "https://restcountries.com/v3.1/all"
        XCTAssertEqual(urlService.getCountriesApiUrl(version: "3.1"), expectedURL)
    }
}
