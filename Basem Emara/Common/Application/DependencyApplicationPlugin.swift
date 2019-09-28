//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamCore
import ZamzamUI

final class DependencyApplicationPlugin: ApplicationPlugin {
    
    private let container = Container {
        Dependency { AppModule() as SwiftyPressModule }
        Dependency { SceneModule() as SceneModuleType }
        Dependency { DeepLinkModule() as DeepLinkModuleType }
        Dependency { HomeModule() as HomeModuleType }
        Dependency { ShowBlogModule() as ShowBlogModuleType }
        Dependency { ListFavoritesModule() as ListFavoritesModuleType }
        Dependency { ListPostsModule() as ListPostsModuleType }
        Dependency { ShowPostModule() as ShowPostModuleType }
        Dependency { SearchPostsModule() as SearchPostsModuleType }
        Dependency { ListTermsModule() as ListTermsModuleType }
        Dependency { ShowMoreModule() as ShowMoreModuleType }
    }
            
    init() {
        container.build()
    }
}
