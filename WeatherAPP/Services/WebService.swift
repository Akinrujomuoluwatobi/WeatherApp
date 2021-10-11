//
//  WebService.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 09/10/2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    
}

struct Resource<T: Mappable> {
    let url : URL
    var httpMethod: HTTPMethod
    var body: Mappable?
    
    init(url: URL, httpMethod: HTTPMethod = .get, body: Mappable?) {
        self.url = url
        self.httpMethod = httpMethod
        self.body = body
    }
}


//This is more like a generic method to make network calls.
class WebServices {
    //Create a function load of generic type T from the Resource Strucr
    func load<T>(resource: Resource<T>, completion: @escaping (NetworkResponseModel) -> Void) { // The Result<T, NetworkError> is available in Swift 5 the first param is the response when successful and the second param is the response when their is an Error.
        //let headers = NetworkUtils.getHeader()
        print(resource.body?.toJSON())
        Alamofire.request(resource.url, method: resource.httpMethod, parameters: resource.body?.toJSON(), encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<T>) in
            let networkResponse = NetworkResponseModel(statusCode: (response.response?.statusCode ?? 0))
            print(response.response?.statusCode)
            //print(response.data.asJson())
            switch response.result {
            case .success(let value):
                if networkResponse.isSuccess() {
                    print(value.toJSON())
                    completion(NetworkResponseModel(statusCode: response.response?.statusCode ?? 200, errorMessage: nil, errorDesc: nil, data: value, success: true))
                } else if networkResponse.isFailed(){
                    
                    if let data = response.data{
                        do {
                            //GET ERROR RESPONSE DATA
                            let json = try JSON(data: data)
                            print("JSON signIn Response ==> \(json)")
                            completion(NetworkResponseModel(statusCode: networkResponse.statusCode, errorMessage: networkResponse.getErrorMessage(_data: json), errorDesc: networkResponse.getErrorDescription(_data: json), data: nil, success: false))
                        } catch {
                            completion(NetworkResponseModel(statusCode: networkResponse.statusCode, errorMessage: error.localizedDescription, data: nil, success: false))
                        }
                    }
                }else{
                    if let data = response.data{
                        do {
                            //GET ERROR RESPONSE DATA
                            let json = try JSON(data: data)
                            print("JSON signIn Response ==> \(json)")
                            completion(NetworkResponseModel(statusCode: networkResponse.statusCode, errorMessage: networkResponse.getErrorMessage(_data: json), errorDesc: networkResponse.getErrorDescription(_data: json), data: nil, success: false))
                        } catch {
                            completion(NetworkResponseModel(statusCode: networkResponse.statusCode, errorMessage: error.localizedDescription, data: nil, success: false))
                        }
                    }
                }
            case .failure(let error):
                completion(NetworkResponseModel(statusCode: response.response?.statusCode ?? 400, errorMessage: error.localizedDescription, errorDesc: nil, data: nil, success: false))
                
            }
        }
    }
    
}
