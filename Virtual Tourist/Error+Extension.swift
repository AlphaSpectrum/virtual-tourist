//
//  Error+Extension.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/23/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import Foundation

extension Error {
    typealias AnyFunction = (() -> Void)
    func reportError(_ handler: AnyFunction) {
        handler()
    }
}
