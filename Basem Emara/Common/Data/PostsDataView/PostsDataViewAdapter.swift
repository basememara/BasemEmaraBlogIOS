//
//  PostDataViewAdapter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

class PostsDataViewAdapter: NSObject {
    private let dataView: DataViewable
    private weak var delegate: PostsDataViewDelegate?
    private(set) var viewModels = [PostsDataViewModel]()
    
    init(for dataView: DataViewable, delegate: PostsDataViewDelegate? = nil) {
        self.dataView = dataView
        self.delegate = delegate
        
        super.init()
        
        // Set data view delegates
        if let tableView = dataView as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
        } else if let collectionView = dataView as? UICollectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}

extension PostsDataViewAdapter {
    
    func reloadData(with viewModels: [PostsDataViewModel]) {
        self.viewModels = viewModels
        
        dataView.reloadData()
        delegate?.postsDataViewDidReloadData()
    }
}

// MARK: - UITableView delegates

extension PostsDataViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Handle cell highlight
        
        let model = viewModels[indexPath.row]
        delegate?.postsDataView(didSelect: model, at: indexPath, from: tableView)
    }
}

extension PostsDataViewAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        (cell as? PostsDataViewCell)?.bind(viewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionView delegates

extension PostsDataViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) //Handle cell highlight
        
        let model = viewModels[indexPath.row]
        delegate?.postsDataView(didSelect: model, at: indexPath, from: collectionView)
    }
}

extension PostsDataViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath]
        (cell as? PostsDataViewCell)?.bind(viewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionView delegates

extension PostsDataViewAdapter {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.postsDataViewWillBeginDragging(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.postsDataViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
