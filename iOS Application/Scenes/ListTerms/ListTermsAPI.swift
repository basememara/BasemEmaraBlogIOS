//
//  ListTermsInterfaces.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

protocol ListTermsInteractorType: InteractorType {
    func fetchTerms(with request: ListTermsAPI.FetchTermsRequest)
}

protocol ListTermsPresenterType: PresenterType {
    func displayTerms(for response: ListTermsAPI.TermsResponse)
    func displayTerms(error: DataError)
}

protocol ListTermsRenderType: RenderType {
    func listPosts(params: ListPostsAPI.Params)
}

// MARK: - Namespace

enum ListTermsAPI {
    
    struct FetchTermsRequest {}
    
    struct TermsResponse {
        let terms: [TermType]
    }
}
