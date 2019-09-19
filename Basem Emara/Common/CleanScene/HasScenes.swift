//
//  HasScenes.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-05-18.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

/// The `scenes` property is provided as a factory for creating scenes.
protocol HasScenes {}
extension HasScenes {
    
    /// Container for scene dependency instance factories
    var scenes: SceneDependable {
        return InjectionStorage.scenes
    }
}

/// Adopters can assign a scene factory to use for instances.
protocol SceneInjection {}
extension SceneInjection {
    
    /// Declare core dependency container to use
    func inject(scenes: SceneDependable) {
        InjectionStorage.scenes = scenes
    }
}

// Statically store the scene factory in memory.
private struct InjectionStorage {
    static var scenes: SceneDependable = SceneModule()
}
