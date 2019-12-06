//
//  CoreApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress
import ZamzamCore

final class DependencyPlugin: ApplicationPlugin {
    
    private let dependencies = Dependencies {
        Module { AppCore() as SwiftyPressCore }
        Module { SceneRender(core: AppCore()) as SceneRenderType }
        Module { DeepLinkModule() as DeepLinkModuleType }
        
        //Module { HomeModule() as HomeCoreType }
        //Module { ShowBlogModule() as ShowBlogModuleType }
        //Module { ListFavoritesCore() as ListFavoritesCoreType }
        Module { ListPostsModule() as ListPostsModuleType }
        Module { ShowPostModule() as ShowPostModuleType }
        Module { SearchPostsModule() as SearchPostsModuleType }
        Module { ListTermsModule() as ListTermsModuleType }
        Module { ShowMoreModule() as ShowMoreModuleType }
    }
            
    init() {
        dependencies.build()
    }
}
