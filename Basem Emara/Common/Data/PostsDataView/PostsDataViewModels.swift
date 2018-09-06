//
//  PostsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

struct PostsDataViewModel {
    let id: Int
    let title: String
    let summary: String
    let date: String
    let imageURL: String?
}

extension PostsDataViewModel {
    
    init(from object: PostType, media: MediaType?, dateFormatter: DateFormatter) {
        self.id = object.id
        self.title = object.title
        self.summary = !object.excerpt.isEmpty ? object.excerpt
            : object.content.prefix(150).string.htmlStripped.htmlDecoded
        self.date = dateFormatter.string(from: object.createdAt)
        self.imageURL = media?.link
    }
}

protocol PostsDataViewCell {
    func bind(_ model: PostsDataViewModel)
}
