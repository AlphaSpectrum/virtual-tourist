//
//  UIImageView+Extension.swift
//  Virtual Tourist
//
//  Created by Alan Campos on 8/29/17.
//  Copyright © 2017 Alan Campos. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill, completion: @escaping () -> Void) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            performUIUpdatesOnMain {
                completion()
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill, completion: @escaping () -> Void) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode, completion: {
            completion()
        })
    }
}