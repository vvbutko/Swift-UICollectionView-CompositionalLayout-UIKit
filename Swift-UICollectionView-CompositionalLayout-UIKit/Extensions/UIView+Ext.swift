//
//  UIView+Ext.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-01-30.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView, useSafeArea: Bool = false, inset: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if useSafeArea {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: inset),
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -inset)
            ])
        } else {
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset),
                topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
            ])
        }
    }
}
