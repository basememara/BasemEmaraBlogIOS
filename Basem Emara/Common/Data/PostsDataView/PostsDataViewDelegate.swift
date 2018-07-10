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
    func postsDataViewDidReloadData()
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView)
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

// Optional conformance
extension PostsDataViewDelegate {
    func postsDataViewDidReloadData() {}
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
}
