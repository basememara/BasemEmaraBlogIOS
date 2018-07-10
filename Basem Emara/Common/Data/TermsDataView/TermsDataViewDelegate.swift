//
//  TagsDataViewDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

protocol TermsDataViewDelegate: class {
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable)
    func termsDataView(willDisplay model: TermsDataViewModel, in cell: UITableViewCell, at indexPath: IndexPath, from dataView: DataViewable)
    func termsDataViewDidReloadData()
}

// Optional conformance
extension TermsDataViewDelegate {
    func termsDataView(willDisplay model: TermsDataViewModel, in cell: UITableViewCell, at indexPath: IndexPath, from dataView: DataViewable) {}
    func termsDataViewDidReloadData() {}
}
