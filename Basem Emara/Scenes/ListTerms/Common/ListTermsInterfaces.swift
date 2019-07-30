//
//  ListTermsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamKit

protocol ListTermsBusinessLogic: AppBusinessLogic {
    func fetchTerms(with request: ListTermsModels.FetchTermsRequest)
}

protocol ListTermsPresentable: AppPresentable {
    func presentTerms(for response: ListTermsModels.TermsResponse)
    func presentTerms(error: DataError)
}

protocol ListTermsDisplayable: class, AppDisplayable {
    func displayTerms(with viewModels: [TermsDataViewModel])
}

protocol ListTermsRoutable: AppRoutable {
    func listPosts(params: ListPostsModels.Params)
}
