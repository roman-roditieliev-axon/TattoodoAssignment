//
//  UIScrollViewExtension.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 25.06.2021.
//

import UIKit

extension UIScrollView {
    func scrollToBotoom(offset: CGFloat = 30) -> Bool {
        return (self.contentOffset.y + self.frame.size.height + offset) > self.contentSize.height
    }
}
