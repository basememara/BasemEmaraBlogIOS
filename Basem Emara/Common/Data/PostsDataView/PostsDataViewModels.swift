//
//  PostsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

struct PostsDataViewModel {
    let id: Int
    let title: String
    let summary: String
    let date: String
    let imageURL: String?
}

protocol PostsDataViewCell {
    func bind(_ model: PostsDataViewModel)
}
