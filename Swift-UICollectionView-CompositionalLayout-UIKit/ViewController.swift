//
//  ViewController.swift
//  Swift-UICollectionView-CompositionalLayout-UIKit
//
//  Created by Vladimir Butko on 2022-04-03.
//

import UIKit

final class ViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case groups
        case projects

        var sectionTitle: String {
            switch self {
            case .groups: return ""
            case .projects: return "Projects"
            }
        }
    }

    enum Item: Hashable {
        case group(Int)
        case project(Int)
    }
    
    private var projects: [Int: Project] = [
        Project.stubHome.id: Project.stubHome,
        Project.stubWork.id: Project.stubWork,
        Project.stubVacation.id: Project.stubVacation,
        Project.stubWeekends.id: Project.stubWeekends,
        Project.stubEducation.id: Project.stubEducation,
        Project.stubResolutions.id: Project.stubResolutions,
    ]
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectItem(collectionView: collectionView)
        refreshSnapshot()
    }

    private func configureViewController() {
        title = "Tasks"
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func configureHierarchy() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
}

// MARK: - DataSource

extension ViewController {
    
    private func configureDataSource() {
        // Cell Registrations
        let groupsCellRegistration = makeGroupsCellRegistration()
        let projectCellRegistration = makeProjectCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .group(let groupId):
                let cell = collectionView.dequeueConfiguredReusableCell(using: groupsCellRegistration, for: indexPath, item: groupId)
                return cell
            
            case .project(let projectId):
                let cell = collectionView.dequeueConfiguredReusableCell(using: projectCellRegistration, for: indexPath, item: projectId)
                return cell
            }
        })
        
        configureSupplementaryViews()
        
        refreshSnapshot()
    }
    
    private func configureSupplementaryViews() {
        // Supplementary registrations
        let headerCellRegistration = makeSectionHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            if elementKind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
            } else {
                return nil
            }
        }
    }
    
    private func refreshSnapshot() {
        let newSnapshot = makeSnapshot()
        
        let shouldAnimate = collectionView.numberOfSections != 0
        dataSource.apply(newSnapshot, animatingDifferences: shouldAnimate, completion: nil)
    }
    
    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections(Section.allCases)
        
        let groupItems = TasksGroup.allCases.map { Item.group($0.id) }
        snapshot.appendItems(groupItems, toSection: .groups)
        
        let sortedProjectItems = Array(projects.values) // array of projects from the dictionary. [Project]
            .sorted(by: { $0.order < $1.order }) // sorted by order. [Project]
            .map { Item.project($0.id) } // wrapped into Items. [Item]
        snapshot.appendItems(sortedProjectItems, toSection: .projects)
        
        return snapshot
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let destinationVC: UIViewController
        switch item {
        case .group(let groupID):
            guard let group = TasksGroup(rawValue: groupID) else { return }
            destinationVC = GroupTasksViewController(tasksGroup: group)
        
        case .project(let projectID):
            guard let project = projects[projectID] else { return }
            destinationVC = ProjectTasksViewController(project: project)
        }
        
        show(destinationVC, sender: nil)
    }
}

// MARK: - CollectionView Layout

extension ViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            
            switch sectionKind {
            case .groups:
                configuration.headerMode = .none
            case .projects:
                configuration.headerMode = .supplementary
            }

            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
}

// MARK: - Cell Registrations

extension ViewController {
    
    private func makeGroupsCellRegistration() -> UICollectionView.CellRegistration<TaskManagerListCell, Int> {
        return UICollectionView.CellRegistration<TaskManagerListCell, Int> { [weak self] (cell, indexPath, groupId) in
            guard let self = self,
                  let tasksGroup = TasksGroup(rawValue: groupId)
            else { return }
            
            let icon = UIImage(systemName: tasksGroup.symbolName)
            let randomNumberOfTasks = Int.random(in: 0..<10) // to randomly populate subtitle
            
            var content = UIListContentConfiguration.sidebarCell()
            
            self.updateCellContent(title: tasksGroup.title, icon: icon, numberOfTasks: randomNumberOfTasks, content: &content)
            self.updateSidebarCellConfiguration(cell: cell, iconTintColor: tasksGroup.symbolColor, isGroupCell: true, content: &content)
            cell.contentConfiguration = content
            
            if #available(iOS 15.0, *) {
                cell.configurationUpdateHandler = { [unowned self] (cell, state) in
                    var background = UIBackgroundConfiguration.listSidebarCell().updated(for: state)
                    self.updateBackgroundConfiguration(background: &background, state: state)
                    cell.backgroundConfiguration = background
                }
            } else {
                // Background configuration for iOS14 is configured in the TaskManagerListCell
            }
        }
    }
    
    private func makeProjectCellRegistration() -> UICollectionView.CellRegistration<TaskManagerListCell, Int> {
        return UICollectionView.CellRegistration<TaskManagerListCell, Int> { [weak self] (cell, _, projectID) in
            guard let self = self else { return }
                        
            guard let project = self.projects[projectID] else { return }
            
            let icon = UIImage(systemName: project.symbolName)
            let randomNumberOfTasks = Int.random(in: 0..<10) // to randomly populate subtitle
            
            var content = UIListContentConfiguration.sidebarCell()
            self.updateCellContent(title: project.title, icon: icon, numberOfTasks: randomNumberOfTasks, content: &content)
            self.updateSidebarCellConfiguration(cell: cell, iconTintColor: project.symbolColor, isGroupCell: false, content: &content)
            cell.contentConfiguration = content
            
            if #available(iOS 15.0, *) {
                cell.configurationUpdateHandler = { [unowned self] (cell, state) in
                    var background = UIBackgroundConfiguration.listSidebarCell().updated(for: state)
                    self.updateBackgroundConfiguration(background: &background, state: state)
                    cell.backgroundConfiguration = background
                }
            } else {
                // Background configuration for iOS14 is configured in the TaskManagerListCell
            }
        }
    }
    
    private func makeSectionHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, indexPath) in
            guard let sectionKind = Section(rawValue: indexPath.section) else { return }
                        
            var content = UIListContentConfiguration.sidebarHeader()
            content.text = sectionKind.sectionTitle
            content.textProperties.color = .tint
            headerView.contentConfiguration = content
        }
    }
    
    // MARK: Helpers
    
    private func updateCellContent(title: String, icon: UIImage?, numberOfTasks: Int?, content: inout UIListContentConfiguration) {
        content.image = icon
        content.text = title
        
        if let numberOfTasks = numberOfTasks, numberOfTasks > 0 {
            content.secondaryText = String(numberOfTasks)
        }
    }
    
    private func updateSidebarCellConfiguration(cell: UICollectionViewCell, iconTintColor: UIColor?, isGroupCell: Bool, content: inout UIListContentConfiguration) {
        
        content.textProperties.font = isGroupCell ? .preferredFont(forTextStyle: .headline) : .preferredFont(forTextStyle: .body)
        content.textProperties.color = .label
        content.secondaryTextProperties.color = .secondaryLabel
        
        content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 26)
        content.imageProperties.tintColor = isGroupCell ? iconTintColor?.withAlphaComponent(0.85) : iconTintColor?.withAlphaComponent(0.80)
        content.imageToTextPadding = 12
        
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        content.textProperties.allowsDefaultTighteningForTruncation = false
        content.prefersSideBySideTextAndSecondaryText = true
    }
    
    private func updateBackgroundConfiguration(background: inout UIBackgroundConfiguration, state: UICellConfigurationState) {
        // Updates Sidebar cell background color for states
        if state.isHighlighted {
            background.backgroundColor = .secondarySystemFill
        } else if state.isSelected {
            background.backgroundColor = .secondarySystemFill
        }
    }
}


