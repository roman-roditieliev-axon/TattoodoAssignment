//
//  Constants.swift
//  TattoodoAssignment (iOS)
//
//  Created by User on 01.07.2021.
//

import UIKit

struct Constants {
    
    struct IndentsAndSizes {
        static let headerHeight: CGFloat = 610
        static let tattooImageHeight: CGFloat = 450
        static let tattooShareSectionHeight: CGFloat = 60
        static let artistDescriptionHeight: CGFloat = 50
        static let circleItemsSize: CGFloat = 40
        static let relatedViewHeight: CGFloat = 660
        static let corner: CGFloat = 20
        static let spacing10: CGFloat = 10
        static let spacing15: CGFloat = 15
    }
    
    struct Images {
        static let home: UIImage = UIImage(systemName: "house") ?? UIImage()
        static let info: UIImage = UIImage(systemName: "info.circle") ?? UIImage()
        static let like: UIImage = UIImage(systemName: "heart") ?? UIImage()
        static let share: UIImage = UIImage(systemName: "square.and.arrow.up") ?? UIImage()
        static let avatar: UIImage = UIImage(systemName: "person.circle") ?? UIImage()
    }
}
