//
//  Project.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-01-30.
//

import UIKit

struct Project {
    let id: Int
    let title: String
    let symbolName: String
    let symbolColor: UIColor
    let order: Int
    
    init(id: Int, title: String, symbolName: String?, symbolColor: UIColor?, order: Int) {
        self.id = id
        self.title = title
        self.symbolName = symbolName ?? "folder"
        self.symbolColor = symbolColor ?? .systemIndigo
        self.order = order
    }
}

extension Project {
    
    static let stubHome = Project(id: 1, title: "Home", symbolName: "house.circle.fill", symbolColor: .systemGreen, order: 1)
    static let stubWork = Project(id: 2, title: "Work", symbolName: "briefcase.circle.fill", symbolColor: .systemGray, order: 2)
    static let stubVacation = Project(id: 3, title: "Vacation in Paris", symbolName: "airplane.circle.fill", symbolColor: .systemTeal, order: 3)
    static let stubWeekends = Project(id: 4, title: "Weekends", symbolName: "hand.thumbsup.circle.fill", symbolColor: .systemBlue, order: 4)
    static let stubEducation = Project(id: 5, title: "Self-Education", symbolName: "graduationcap.circle.fill", symbolColor: .label, order: 5)
    static let stubResolutions = Project(id: 6, title: "New Year's Resolutions", symbolName: "flag.circle.fill", symbolColor: .systemPink, order: 6)
}
