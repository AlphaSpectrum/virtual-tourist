//
//  JSONHandler.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/23/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

struct JSON {
    let dataAsDictionary: [String : AnyObject]!
    
    init(data: Data) {
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        self.dataAsDictionary = jsonData as! [String : AnyObject]
    }
}
