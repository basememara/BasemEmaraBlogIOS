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
        //Module { DeepLinkCore() as DeepLinkCoreType }
        
        //Module { HomeModule() as HomeCoreType }
        //Module { ShowBlogModule() as ShowBlogModuleType }
        //Module { ListFavoritesCore() as ListFavoritesCoreType }
        //Module { ListPostsCore() as ListPostsCoreType }
        //Module { ShowPostCore() as ShowPostCoreType }
        //Module { SearchPostsCore() as SearchPostsCoreType }
        //Module { ListTermsCore() as ListTermsCoreType }
        //Module { ShowMoreCore() as ShowMoreCoreType }
    }
            
    init() {
        dependencies.build()
    }
}
