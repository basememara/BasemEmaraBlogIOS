//
//  ViewRepresentable.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-13.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit.UIViewController
#if canImport(SwiftUI)
import SwiftUI
#endif

/// Convenient conversion from `UIViewController` to SwiftUI `View`.
@available(iOS 13, *)
struct ViewRepresentable: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Unused
    }
}
