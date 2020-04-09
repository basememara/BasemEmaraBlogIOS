//
//  MiddlewareType.swift
//
//  Created by Basem Emara on 2019-11-26.
//

/// The middleware that passively executes tasks based on any action before it it sent to a reducer.
public protocol MiddlewareType {
    func callAsFunction(_ action: ActionType)
}
