//
//  Connectable.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/23/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

protocol Connectable: Error {
    typealias CCompletion = (_ data: Data?, _ success: Bool?, _ error: String?) -> Void
    func connect(to url: URL, httpHeaders: [String : String]?, httpBody: String?, method: HTTPMethod, completionHandler: @escaping CCompletion)
    func generateURL(using segments: [URLSegment : String] ,queries: [String : AnyObject]?, withPathExtension: String?) -> URL
}
