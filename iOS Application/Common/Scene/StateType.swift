//
//  StateType.swift
//
//  Created by Basem Emara on 2019-11-25.
//

/// The data of the component.
public protocol StateType {
    associatedtype Action: ActionType
    mutating func receive(_ action: Action)
}

public protocol ActionType {}
public typealias Action<State: StateType> = (State.Action) -> Void
