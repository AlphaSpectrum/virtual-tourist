//
//  Connection.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/21/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//
import Foundation

internal class Connection: Connectable {
    
    internal func connect(to url: URL, httpHeaders: [String : String]?, httpBody: String?, method: HTTPMethod, completionHandler: @escaping CCompletion) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "\(method)".uppercased()
        
        if httpHeaders != nil {
            for (key, value) in httpHeaders! {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if httpBody != nil {
            request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard (error == nil) else {
                self.reportError {
                    let error = "No internet connection."
                    completionHandler(nil, false, error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.reportError {
                    let error = "Invalid username or password."
                    completionHandler(nil, false, error)
                }
                return
            }
            
            guard let data = data else {
                self.reportError {
                    let error = "Server unresponsive."
                    completionHandler(nil, false, error)
                }
                return
            }
            completionHandler(data, true, nil)
        }
        task.resume()
    }
    
    internal func generateURL(using segments: [URLSegment : String], queries: [String : AnyObject]?, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = segments[.scheme]
        components.host = segments[.host]
        components.path = segments[.path]! + (withPathExtension ?? "")
        
        if queries != nil {
            components.queryItems = [URLQueryItem]()
            for (key, value) in queries! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        return components.url!
    }
}
