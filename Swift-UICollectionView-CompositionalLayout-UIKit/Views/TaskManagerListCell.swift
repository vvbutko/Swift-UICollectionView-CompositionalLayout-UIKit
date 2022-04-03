//
//  TaskManagerListCell.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-02-06.
//

import UIKit

final class TaskManagerListCell: UICollectionViewListCell {
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if #available(iOS 15.0, macOS 12.0, *) {
            // Background configuration is updated on cell registration in .configurationUpdateHandler (new in iOS15)
        } else {
            var background = UIBackgroundConfiguration.listSidebarCell()
            
            if state.isSelected || state.isHighlighted {
                background.backgroundColor = .secondarySystemFill
            }
            
            backgroundConfiguration = background
        }
    }
}
