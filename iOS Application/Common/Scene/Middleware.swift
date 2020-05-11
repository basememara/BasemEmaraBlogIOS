//
//  Middleware.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-11-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// The middleware that passively executes tasks based on any action before it it sent to a reducer.
public protocol Middleware {
    func callAsFunction(_ action: Action)
}
