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

protocol ListTermsCoreType {
    func action(with viewController: ListTermsDisplayable?) -> ListTermsActionable
    func presenter(with viewController: ListTermsDisplayable?) -> ListTermsPresentable
    func router(with viewController: UIViewController?) -> ListTermsRouterable
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

protocol ListTermsRouterable {
    func listPosts(params: ListPostsAPI.Params)
}

// MARK: - Request/Response

extension ListTermsAPI {
    
    struct FetchTermsRequest {
        
    }
    
    struct TermsResponse {
        let terms: [TermType]
    }
}
