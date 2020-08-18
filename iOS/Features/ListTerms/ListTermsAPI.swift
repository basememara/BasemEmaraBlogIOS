//
//  ListTermsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamUI

protocol ListTermsInteractable: Interactor {
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest)
}

protocol ListTermsPresentable: Presenter {
    func displayTerms(for response: ListTermsAPI.TermsResponse)
    func displayTerms(error: SwiftyPressError)
}

protocol ListTermsRenderable: Render {
    func listPosts(params: ListPostsAPI.Params)
}

// MARK: - Namespace

enum ListTermsAPI {
    
    struct FetchTermsRequest {}
    
    struct TermsResponse {
        let terms: [Term]
    }
}
