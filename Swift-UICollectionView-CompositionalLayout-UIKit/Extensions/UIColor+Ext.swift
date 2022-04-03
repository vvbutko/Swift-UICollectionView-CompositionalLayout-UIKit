//
//  UIColor+Ext.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-02-06.
//

import UIKit

extension UIColor {
    
    static var tint: UIColor = {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark
            ? .systemOrange
            : .systemBlue
        }
    }()
}
