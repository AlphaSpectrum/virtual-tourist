//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/21/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

struct Flickr {
    
    struct URL {
        static var scheme = "https"
        static var host = "api.flickr.com"
        static var path = "/services/rest/"
    }
    
    struct Query {
        static var photoSearch = "flickr.photos.search"
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct key {
        static var api = "api_key"
    }
    
    struct value {
        static var api = "109015afccb7dd463e8461a11820dda8"
        static var secret = "acad39bebe33cc09"
    }
    
}
