//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/23/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct PhotoInformation {
    var id: String!
    var url: String!
}

struct FlickrPhoto {
    var photo: [PhotoInformation]?
    
    init(_ arrayDictionary: [[String: AnyObject]]) {
        var photos = [PhotoInformation]()
        for index in arrayDictionary {
            if let url = index["url_m"],
                let id = index["id"] {
                let photo = PhotoInformation(id: id as! String, url: url as! String)
                photos.append(photo)
            } else {
                print("something went wrong")
            }
        }
        self.photo = photos
    }
}

