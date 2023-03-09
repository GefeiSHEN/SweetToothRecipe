//
//  URLProtocolMock.swift
//  SweetToothRecipeTests
//
//  Created by Gefei Shen on 3/9/23.
//

import Foundation

/**
 A custom implementation of URLProtocol. This struct simulates network requests, which is useful in many testing conditions.
 
 Sample Usage:
 ```swift
 URLProtocolMock.testURLs[url] = (data: data, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
 ```
 */

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: (data: Data, response: HTTPURLResponse)]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url else { return }
        guard let (data, response) = URLProtocolMock.testURLs[url] else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
