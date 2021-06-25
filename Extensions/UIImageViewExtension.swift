//
//  UIImageViewExtension.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 25.06.2021.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.image = image
            }
        }
    }
}
