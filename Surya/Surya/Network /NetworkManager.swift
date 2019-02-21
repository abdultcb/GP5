//
//  NetworkManager.swift
//  Surya
//
//  Created by Abdul on 21/02/19.
//  Copyright © 2019 VirtualEmployee. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    let urlSession = URLSession.shared
    
    static let shared = NetworkManager()
    
    private override init() {
        super.init()
    }
    
    
    /// Creates a request with the server
    ///
    /// - Parameters:
    ///   - requestType: Get or Post type request
    ///   - params: Parameters to be sent over the network for the specifid request
    ///   - onCompletion: Completion handler
    func startRequest(_ requestType: String, params: [String : Any], onCompletion: @escaping ((Data?, Error?) -> Void)) {
        
        let Url = Constants.API.baseURL + Constants.API.getList
        guard let serviceUrl = URL(string: Url) else { return }
      
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = requestType
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        urlSession.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                onCompletion(nil, error)
            }
            onCompletion(data, nil)
            
            }.resume()
        
    }
    
}
