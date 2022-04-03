//
//  TasksGroup.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-01-30.
//

import UIKit

enum TasksGroup: Int, CaseIterable, Identifiable {
    case myTaskFlow
    case focus
    case today
    case upcoming
    case someday
    
    var id: Int { self.rawValue }
    
    var title: String {
        switch self {
        case .myTaskFlow: return "My Task Flow"
        case .focus: return "Focus"
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .someday: return "Someday"
        }
    }
    
    var symbolName: String {
        switch self {
        case .myTaskFlow: return "tray.full.fill" // 􀈬
        case .focus: return "smallcircle.filled.circle" // 􀍷
        case .today: return "star.fill" // 􀋃
        case .upcoming: return "calendar" // 􀉉
        case .someday: return "archivebox" // 􀈭
        }
    }
    
    var symbolColor: UIColor {
        switch self {
        case .myTaskFlow: return .systemBlue
        case .focus: return .systemGreen
        case .today: return .systemYellow
        case .upcoming: return .systemPurple
        case .someday: return .systemGray
        }
    }
}
