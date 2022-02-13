//  HttpUtility.swift
//  Krishi
//
//  Created by MacBook on 26/01/22.
//

import Foundation

class HttpUtility{
    static let shared = HttpUtility()
    var authenticationToken: String? = nil
    var customJsonDecoder: JSONDecoder? = nil
    
    
    private init(){}
    
    
    func request<T: Decodable>(request: APIRequest, resultType: T.Type, completionHandler: @escaping(Result<T?, NetworkError>) -> Void){
        
        switch request.method{
        case .get:
            getData(requestUrl: request.url, resultType: resultType) { completionHandler($0)}
            break
            
        case .post:
            postData(request: request, resultType: resultType) { completionHandler($0)}
            break
            
        case .put:
            putData(requestUrl: request.url, resultType: resultType) { completionHandler($0)}
            break
            
        case .delete:
            deleteData(requestUrl: request.url, resultType: resultType) { completionHandler($0)}
            break
        }
    }
    
    
    private func createUrlRequest(requestUrl: URL) -> URLRequest {
        
        var urlRequest = URLRequest(url: requestUrl)
        if(authenticationToken != nil) {
            urlRequest.setValue(authenticationToken!, forHTTPHeaderField: "authorization")
        }
        
        return urlRequest
    }
    
    private func createJsonDecoder() -> JSONDecoder{
        
            let decoder =  customJsonDecoder != nil ? customJsonDecoder! : JSONDecoder()
            if(customJsonDecoder == nil) {
                decoder.dateDecodingStrategy = .iso8601
            }
            return decoder
        }
    
    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T?{
        
            let decoder = createJsonDecoder()
            do {
                return try decoder.decode(responseType, from: data)
            }catch let error {
                debugPrint("deocding error =>\(error.localizedDescription)")
            }
            return nil
        }
    
    
    //MARK: - GET Api
    private func getData<T: Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping(Result<T?, NetworkError>)-> Void){
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethods.get.rawValue
        
        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - POST Api
    private func postData<T: Decodable>(request: APIRequest, resultType: T.Type, completionHandler: @escaping(Result<T?, NetworkError>)-> Void){
        
        var urlRequest = self.createUrlRequest(requestUrl: request.url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.httpBody = request.requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    //  MARK: - PUT Api
    private func putData<T :Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping(Result<T?, NetworkError>)-> Void){
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethods.put.rawValue
        
        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - DELETE Api
    private func deleteData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void){
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethods.delete.rawValue
        
        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    
   // MARK: - Perform data task
    private func performOperation<T: Decodable>(requestUrl: URLRequest, responseType: T.Type, completionHandler: @escaping(Result<T?, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in
            
            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            if(error == nil && data != nil && data?.count != 0) {
                let response = self.decodeJsonResponse(data: data!, responseType: responseType)
                if(response != nil) {
                    completionHandler(.success(response))
                }else {
                    completionHandler(.failure(NetworkError(withServerResponse: data, forRequestUrl: requestUrl.url!, withHttpBody: requestUrl.httpBody, errorMessage: error.debugDescription, forStatusCode: statusCode!)))
                }
            }
            else {
                let networkError = NetworkError(withServerResponse: data, forRequestUrl: requestUrl.url!, withHttpBody: requestUrl.httpBody, errorMessage: error.debugDescription, forStatusCode: statusCode!)
                completionHandler(.failure(networkError))
            }
        }.resume()
    }
}
