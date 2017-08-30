//
//  ConnectionHandler.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/24/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol FlickrInterface {
    typealias FICompletion = (_ photoObj: [PhotoInformation]?, _ success: Bool, _ error: String?) -> Void
    func getFlickrPhoto(completion: @escaping FICompletion)
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void)
}

class ConnectionHandler: Connection, FlickrInterface {
    var urlSegments: [URLSegment : String]?
    var query: [String : String]?
    var url: URL! {
        get {
            if query != nil {
                let newURL = generateURL(using: urlSegments!, queries: query! as [String : AnyObject])
                return newURL
            } else if urlSegments != nil {
                let newURL = generateURL(using: urlSegments!, queries: nil)
                return newURL
            }
            return nil
        }
    }
    
    func getFlickrPhoto(completion: @escaping FICompletion) {
        guard let url = url else {
            reportError {
                let error = "'url' is nil. Make sure to set segmentedURL or url directly."
                completion(nil, false, error)
            }
            return
        }
        connect(to: url, httpHeaders: nil, httpBody: nil, method: .get, completionHandler: {
            data, success, error in
            
            if success! {
                let json = JSON(data: data!)
                let photos = json.dataAsDictionary["photos"]!
                let flickrPhotoObject = FlickrPhoto(photos["photo"] as! [[String : AnyObject]])
                let photoObj = flickrPhotoObject.photo
                completion(photoObj, true, nil)
            } else {
                completion(nil, false, error)
            }
            
        })
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}

internal extension ConnectionHandler {
    struct shared {
        static var instance = ConnectionHandler()
    }
}


