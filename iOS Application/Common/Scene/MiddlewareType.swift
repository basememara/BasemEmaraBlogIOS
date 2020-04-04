//
//  MiddlewareType.swift
//
//  Created by Basem Emara on 2019-11-26.
//

/// The middleware that passively executes tasks based on any input before it it sent to a reducer.
public protocol MiddlewareType {
    func callAsFunction(_ input: InputType)
}
