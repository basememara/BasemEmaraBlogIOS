//
//  PostsDataViewDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

protocol PostsDataViewDelegate: class {
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable)
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int
    func postsDataViewDidReloadData()
    
    func postsDataView(leadingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView)
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

// Optional conformance
extension PostsDataViewDelegate {
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int { return 1 }
    func postsDataViewDidReloadData() {}
    
    func postsDataView(leadingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? { return nil }
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? { return nil }
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
}
