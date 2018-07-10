//
//  TermsDataViewAdapter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamKit

class TermsDataViewAdapter: NSObject {
    private weak var delegate: TermsDataViewDelegate?
    private let dataView: DataViewable
    private(set) var viewModels = [TermsDataViewModel]()
    
    init(delegate: TermsDataViewDelegate? = nil, for dataView: DataViewable) {
        self.delegate = delegate
        self.dataView = dataView
        
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

extension TermsDataViewAdapter {
    
    func reloadData(with viewModels: [TermsDataViewModel]) {
        self.viewModels = viewModels
        
        dataView.reloadData()
        delegate?.termsDataViewDidReloadData()
    }
}

// MARK: - UITableView delegates

extension TermsDataViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.termsDataView(
            didSelect: element(in: indexPath),
            at: indexPath,
            from: tableView
        )
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.termsDataView(
            willDisplay: element(in: indexPath),
            in: cell,
            at: indexPath,
            from: tableView
        )
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // TODO: Localize
        return numberOfSections > 1 ? taxonomy(for: section).rawValue : nil
    }
}

extension TermsDataViewAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfElements(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        let model = element(in: indexPath)
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "(\(model.count))"
        return cell
    }
}

// MARK: - UICollectionView delegates

extension TermsDataViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.termsDataView(
            didSelect: element(in: indexPath),
            at: indexPath,
            from: collectionView
        )
    }
}

extension TermsDataViewAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfElements(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath]
        assertionFailure("Not implemented")
        return cell
    }
}

// MARK: - Helpers

private extension TermsDataViewAdapter {
    
    var numberOfSections: Int {
        return Set(viewModels.map { $0.taxonomy }).count
    }
    
    func elements(for taxonomy: Taxonomy) -> [TermsDataViewModel] {
        return viewModels.filter { $0.taxonomy == taxonomy }
    }
    
    func elements(in section: Int) -> [TermsDataViewModel] {
        return elements(for: taxonomy(for: section))
    }
    
    func element(in indexPath: IndexPath) -> TermsDataViewModel {
        return elements(in: indexPath.section)[indexPath.row]
    }
    
    func numberOfElements(in section: Int) -> Int {
        return elements(in: section).count
    }
    
    func taxonomy(for section: Int) -> Taxonomy {
        guard numberOfSections > 1 else {
            return viewModels.first?.taxonomy ?? .category
        }
        
        // Categories is considered section 0
        return section == 0 ? .category : .tag
    }
}
