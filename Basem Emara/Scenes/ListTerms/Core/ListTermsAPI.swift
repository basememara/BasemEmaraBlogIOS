//
//  ListTermsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import UIKit
import ZamzamUI

// Scene namespace
enum ListTermsAPI {}

protocol ListTermsModuleType {
    func resolve(with viewController: ListTermsDisplayable?) -> ListTermsActionable
    func resolve(with viewController: ListTermsDisplayable?) -> ListTermsPresentable
    func resolve(with viewController: UIViewController?) -> ListTermsRoutable
}

protocol ListTermsActionable: AppActionable {
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest)
}

protocol ListTermsPresentable: AppPresentable {
    func presentTerms(for response: ListTermsAPI.TermsResponse)
    func presentTerms(error: DataError)
}

protocol ListTermsDisplayable: class, AppDisplayable {
    func displayTerms(with viewModels: [TermsDataViewModel])
}

protocol ListTermsRoutable: AppRoutable {
    func listPosts(params: ListPostsAPI.Params)
}

extension ListTermsAPI {
    
    struct FetchTermsRequest {
        
    }
    
    struct TermsResponse {
        let terms: [TermType]
    }
}
