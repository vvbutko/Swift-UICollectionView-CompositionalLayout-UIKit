//
//  GroupTasksViewController.swift
//  CollectionViewDeselectOnAppear
//
//  Created by Vladimir Butko on 2022-02-06.
//

import UIKit

final class GroupTasksViewController: UIViewController {

    private let group: TasksGroup
    
    init(tasksGroup: TasksGroup) {
        self.group = tasksGroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        addContent()
    }
    
    private func configureViewController() {
        self.title = group.title
        self.view.backgroundColor = .systemBackground
    }
    
    private func addContent() {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "This is an empty GroupTasksViewController"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
