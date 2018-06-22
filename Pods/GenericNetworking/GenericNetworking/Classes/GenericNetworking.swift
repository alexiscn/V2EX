//
//  GenericNetworking.swift
//  GenericNetworking
//
//  Created by xu.shuifeng on 29/11/2017.
//

import Foundation
import Alamofire


/// HTTP request completion callback block
public typealias GenericNetworkingCompletion<T> = (GenericNetworkingResponse<T>) -> Void where T: Codable

/// Structure for upload
public struct GenericMultiPart {
    public let data: Data
    public let name: String
    public let filename: String
    public let mimeType: String
}


/// GenericNetworkingResponse
///
/// - success: request successfully, with your provided type decoded
/// - error: some error occurs
public enum GenericNetworkingResponse<T> where T: Codable {
    case success(T)
    case error(GenericNetworkingError)
}


/// Networking error
///
/// - responseError: http response has an error.
/// - decodeError: `GenericNetworking` can not decode response into your type. please check members type.
/// - serverError: `GenericNetworking` do not known what's wrong with the request
/// - parameterError: `GenericNetworking` can not make a http request due to parameters error, eg: `baseURLString` missing
public enum GenericNetworkingError: Error {
    case responseError(DefaultDataResponse)
    case decodeError(Error, String)
    case serverError(String)
    case parameterError(String)
}


/// Just a simple wrapper around Alamofire with Codeable and Generic supports
///
/// See README for more information
open class GenericNetworking {
    
    /// server base host, eg: https://api.example.com
    public static var baseURLString: String?
    
    /// your can customize request headers, eg: your can add a common cookie for each request
    public static var defaultHeaders: HTTPHeaders?
    
    /// enable GenericNetworking print debugging information, default is `true`
    public static var enableDebugPrint: Bool = true
    
    
    /// make a GET request with whole URL String
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - completion: completion callback
    /// - Returns: return DataRequest
    @discardableResult
    public class func getJSON<T>(URLString: String, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(URLString: URLString, method: .get, parameters: nil, headers: nil, completion: completion)
    }
    
    
    /// make GET request
    ///
    /// - Parameters:
    ///   - path: path
    ///   - completion: completion callback
    /// - Returns: return DataRequest
    @discardableResult
    public class func getJSON<T>(path: String, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(path: path, method: .get, parameters: nil, headers: nil, completion: completion)
    }
    
    /// make GET request
    ///
    /// - Parameters:
    ///   - path: path
    ///   - parameters: parameters
    ///   - completion: completion callback
    /// - Returns: return DataRequest
    @discardableResult
    public class func getJSON<T>(path: String, parameters: Parameters, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(path: path, method: .get, parameters: parameters, headers: nil, completion: completion)
    }
    
    
    /// make GET request
    ///
    /// - Parameters:
    ///   - path: path
    ///   - parameters: parameters
    ///   - headers: headers
    ///   - completion: completion callback
    /// - Returns: return DataRequest
    @discardableResult
    public class func getJSON<T>(path: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(path: path, method: .get, parameters: parameters, headers: headers, completion: completion)
    }
    
    /// make a POST request
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - parameters: parameters
    ///   - headers: headers
    ///   - completion: completion callback
    @discardableResult
    public class func postJSON<T>(URLString: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(URLString: URLString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    
    /// make a request
    /// Note: if you want to use this function, make sure set `baseURLString` first
    ///
    /// - Parameters:
    ///   - path: request API path. eg: /gists
    ///   - parameters: parameters
    ///   - headers: HTTP Headers
    ///   - completion: completion callback
    @discardableResult
    public class func postJSON<T>(path: String, parameters: Parameters?, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        return requestJSON(path: path, method: .post, parameters: parameters, headers: nil, completion: completion)
    }
    
    
    /// upload data
    ///
    /// - Parameters:
    ///   - path: request API path. eg: /gists
    ///   - multiPart: multi part item
    ///   - parameters: parameters
    ///   - completion: completion callback
    public class func upload<T>(path: String, multiPart: GenericMultiPart, parameters: Parameters?, completion: @escaping GenericNetworkingCompletion<T>) {
        upload(path: path, multiParts: [multiPart], parameters: parameters, completion: completion)
    }
    
    
    /// upload data
    ///
    /// - Parameters:
    ///   - path: request API path. eg: /gists
    ///   - data: data tobe upload
    ///   - mimeType: mimeType of data, eg: image/png
    ///   - parameters: parameters
    ///   - completion: completion callback
    public class func upload<T>(path: String, data: Data, mimeType: String, parameters: Parameters?, completion: @escaping GenericNetworkingCompletion<T>) {
        let multiPart = GenericMultiPart(data: data, name: "file", filename: "file", mimeType: mimeType)
        upload(path: path, multiParts: [multiPart], parameters: parameters, completion: completion)
    }
    
    
    /// upload data
    ///
    /// - Parameters:
    ///   - path: request API path. eg: /gists
    ///   - multiParts: multiParts
    ///   - parameters: parameters
    ///   - completion: completion callback
    public class func upload<T>(path: String, multiParts: [GenericMultiPart], parameters: Parameters?, completion: @escaping GenericNetworkingCompletion<T>) {
        
        guard let baseURLString = baseURLString else {
            let errorInfo = "[GenericNetworking] `baseURLString` is nil, make sure `baseURLString` is not nil before your call this function"
            let error = GenericNetworkingError.parameterError(errorInfo)
            let res = GenericNetworkingResponse<T>.error(error)
            completion(res)
            log(errorInfo)
            return;
        }
        let urlString = baseURLString.appending(path)
        let multipartFormData: ((MultipartFormData) -> Void) = { (multiformdata) in
            if let postParams = parameters {
                for (key, value) in postParams {
                    multiformdata.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }
            for part  in multiParts {
                multiformdata.append(part.data, withName: part.name, fileName: part.filename, mimeType: part.mimeType)
            }
        }
        
        let encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void) = { encodingResult in
            switch encodingResult {
            case .failure(let error):
                let responseError = GenericNetworkingError.serverError(error.localizedDescription)
                let res = GenericNetworkingResponse<T>.error(responseError)
                completion(res)
            case .success(let request, _, _):
                request.response(completionHandler: { dataResponse in
                  handleDataResponse(dataResponse, completion: completion)
                })
            }
        }
        Alamofire.upload(multipartFormData: multipartFormData, to: urlString, method: .post, headers: defaultHeaders, encodingCompletion: encodingCompletion)
    }

    
    /// Request
    ///
    /// - Parameters:
    ///   - baseURLString: host URL string, eg: https://api.github.com
    ///   - path: request API path. eg: /gists
    ///   - method: HTTP Method, default is GET
    ///   - parameters: parameters
    ///   - headers: HTTP Headers
    ///   - completion: completion callback
    @discardableResult
    fileprivate class func requestJSON<T>(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        guard let baseURLString = baseURLString else {
            let errorInfo = "[GenericNetworking] `baseURLString` is nil, make sure `baseURLString` is not nil before your call this function"
            let error = GenericNetworkingError.parameterError(errorInfo)
            let res = GenericNetworkingResponse<T>.error(error)
            completion(res)
            log(errorInfo)
            return SessionManager.default.request(path)
        }
        let urlString = baseURLString.appending(path)
        return requestJSON(URLString: urlString, method: method, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    fileprivate class func requestJSON<T>(URLString: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping GenericNetworkingCompletion<T>) -> DataRequest {
        
        // configure HTTP Headers
        var httpHeaders: [String: String] = [:]
        if let header = defaultHeaders {
            httpHeaders = header
        }
        if let headers = headers {
            httpHeaders.merge(headers) { (current, new) in new }
        }
        
        return Alamofire.request(URLString,
                                 method: method,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: httpHeaders).response { (dataResponse) in
                                    
            handleDataResponse(dataResponse, completion: completion)
        }
    }
    
    fileprivate class func handleDataResponse<T>(_ dataResponse: DefaultDataResponse, completion: @escaping GenericNetworkingCompletion<T>) {
        // HTTP Request failed. Handle the error.
        if let error = dataResponse.error {
            let responseError = GenericNetworkingError.responseError(dataResponse)
            let res = GenericNetworkingResponse<T>.error(responseError)
            completion(res)
            let urlString = dataResponse.request?.url?.absoluteString ?? ""
            log("[GenericNetworking] Response Error:\(error.localizedDescription) at URLString:\(urlString)")
            return;
        }
        
        // if we got data, try decode
        if let data = dataResponse.data {
            do {
                // if successfully decoded, completion. otherwise handle the error.
                let json = try JSONDecoder().decode(T.self, from: data)
                let res = GenericNetworkingResponse<T>.success(json)
                completion(res)
            } catch let error as NSError {
                let responseText: String
                if let responseString = String(data: data, encoding: String.Encoding.utf8) {
                    responseText = responseString
                } else {
                    responseText = "can not convert response data to String"
                }
                let decodeError = GenericNetworkingError.decodeError(error, responseText)
                let res = GenericNetworkingResponse<T>.error(decodeError)
                completion(res)
                let info = "[GenericNetworking] JSONDecoder error, origin response text is:\(responseText)"
                log(info)
            }
            return;
        }
        // handle response data is empty
        let dataError = GenericNetworkingError.serverError("response data is nil")
        let res = GenericNetworkingResponse<T>.error(dataError)
        completion(res)
    }
    
}

extension GenericNetworking {
    fileprivate class func log(_ text: String) {
        if enableDebugPrint {
            print(text)
        }
    }
}
