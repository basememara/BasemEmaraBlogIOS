//
//  ActionType.swift
//
//  Created by Basem Emara on 2019-11-22.
//

/// The action component of the scene.
public protocol ActionType {}

/// The action creator component of the scene.
public protocol InteractorType {
    associatedtype Action: ActionType
    
    /// Performs the asynchronous task and sends a new action.
    var send: (Action) -> Void { get }
}
