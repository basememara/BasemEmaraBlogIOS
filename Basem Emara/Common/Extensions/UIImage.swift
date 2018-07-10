//
//  UIImage.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    /// Set an image with a URL and placeholder using caching.
    ///
    /// - Parameters:
    ///   - url: The URL of the image.
    ///   - placeholder: The placeholder image when retrieving the image at the URL.
    func setURL(_ url: String?, placeholder: String? = "placeholder", referenceSize: CGSize? = nil, tintColor: UIColor? = nil, contentMode: ContentMode? = nil) {
        let placeholder = placeholder != nil ? UIImage(named: placeholder!) : nil
        setURL(url, placeholder: placeholder, referenceSize: referenceSize, tintColor: tintColor, contentMode: contentMode)
    }
    
    /// Set an image with a URL and placeholder using caching.
    ///
    /// - Parameters:
    ///   - url: The URL of the image.
    ///   - placeholder: The placeholder image when retrieving the image at the URL.
    func setURL(_ url: String?, placeholder: UIImage?, referenceSize: CGSize? = nil, tintColor: UIColor? = nil, contentMode: ContentMode? = nil) {
        guard let url = url, !url.isEmpty, let urlResource = URL(string: url) else {
            image = placeholder
            return
        }
        
        // Build options if applicable
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        var processor: ImageProcessor? = nil
        
        if let referenceSize = referenceSize {
            let resizeProcessor = ResizingImageProcessor(referenceSize: referenceSize, mode: contentMode ?? .none)
            processor = processor?.append(another: resizeProcessor) ?? resizeProcessor
        }
        
        if let processor = processor {
            options.append(.processor(processor))
        }
        
        kf.setImage(
            with: urlResource,
            placeholder: placeholder,
            options: options,
            completionHandler: { (image, error, cacheType, imageUrl) in
                guard let tintColor = tintColor else { return }
                self.tintColor = tintColor
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
            }
        )
    }
}
