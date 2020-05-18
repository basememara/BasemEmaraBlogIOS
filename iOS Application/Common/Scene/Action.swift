//
//  Action.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-05-18.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// The set of actions used to mutate the state.
public protocol Action {}

/// A closure that dispatches the action to mutate the state.
typealias Dispatcher<T: Action> = (T) -> Void
