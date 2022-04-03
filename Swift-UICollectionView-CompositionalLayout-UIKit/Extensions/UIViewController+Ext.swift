//
//  UIViewController+Ext.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-01-30.
//

import UIKit

extension UIViewController {
    
    /// Deselects selected cells in the provided CollectionView
    ///
    /// As a common use case: call the method in the `viewWillAppear()`
    func deselectItem(collectionView: UICollectionView?) {
        guard let collectionView = collectionView else { return }
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    collectionView.deselectItem(at: indexPath, animated: true)}) { (context) in
                        if context.isCancelled {
                            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                        }
                    }
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
}

