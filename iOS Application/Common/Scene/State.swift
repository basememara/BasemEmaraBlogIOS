//
//  StateType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-11-25.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

/// The data of the component.
public protocol State {
    associatedtype ActionType: Action
    mutating func receive(_ action: ActionType)
}

public protocol Action {}
