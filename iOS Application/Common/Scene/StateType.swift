//
//  StateType.swift
//
//  Created by Basem Emara on 2019-11-25.
//

/// The data of the component.
public protocol StateType {
    associatedtype Input: InputType
    mutating func receive(_ input: Input)
}

public protocol InputType {}
public typealias Input<State: StateType> = (State.Input) -> Void
