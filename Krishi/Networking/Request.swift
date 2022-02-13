//
//  HURequest.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation

protocol RequestProtocol {
    var url: URL { get set }
    var method: HttpMethods {get set}
}

public struct APIRequest : RequestProtocol {
    var url: URL
    var method: HttpMethods
    var requestBody: Data? = nil

    init(withUrl url: URL, forHttpMethod method: HttpMethods, requestBody: Data? = nil) {
        self.url = url
        self.method = method
        self.requestBody = requestBody != nil ? requestBody : nil
    }
}

