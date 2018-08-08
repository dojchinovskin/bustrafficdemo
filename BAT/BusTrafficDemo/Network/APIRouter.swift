//
//  APIRouter.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 8/8/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case getStations
    
    var method: Alamofire.HTTPMethod {
        switch self {
            default: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getStations: return Network.Endpoints.baseUrl
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        default: return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)
        var urlRequest = URLRequest(url: url!)
        
        let encoding: ParameterEncoding = (method == .get) ? Alamofire.URLEncoding.default : Alamofire.JSONEncoding.default
        urlRequest.httpMethod = method.rawValue
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    
}
