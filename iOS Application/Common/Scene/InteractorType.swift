//
//  InteractorType.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-02.
//

/// The action creator component of the scene.
public protocol InteractorType {
    associatedtype Action: ActionType
    
    /// Performs the asynchronous task and sends a new action.
    var action: (Action) -> Void { get }
}
