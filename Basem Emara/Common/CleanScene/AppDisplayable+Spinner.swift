//
//  AppDisplayable+Spinner.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-11-14.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit
import PKHUD

extension AppDisplayable where Self: UIViewController {
    
    /// Displays heads-up display for waiting period.
    ///
    /// - Parameters:
    ///   - type: Type of spinner to display.
    ///   - delay: Amount of time to display the spinner.
    private func showSpinner(for type: HUDContentType = .progress, delay: TimeInterval = 10) {
        endEditing()
        
        guard delay > 0 else { return HUD.flash(type, delay: delay) }
        HUD.flash(type, delay: delay)
    }
    
    /// Hides the head-up display.
    func hideSpinner() {
        HUD.hide()
    }
}

extension AppDisplayable where Self: UIViewController {
    
    /// Displays heads-up display for waiting period.
    ///
    /// - Parameters:
    ///   - label: Text to display for the spinner.
    ///   - delay: Amount of time to display the spinner.
    func display(label: Localizable, delay: TimeInterval = 10) {
        showSpinner(for: .label(.localized(label)), delay: delay)
    }
    
    /// Displays heads-up display for waiting period.
    ///
    /// - Parameters:
    ///   - title: Text to display for the spinner.
    ///   - subtitle: Text to display for the spinner subtitle.
    ///   - delay: Amount of time to display the spinner.
    func display(progress title: Localizable, subtitle: Localizable? = nil, delay: TimeInterval = 10) {
        let type: HUDContentType = .labeledProgress(
            title: .localized(title),
            subtitle: {
                guard let subtitle = subtitle else { return nil }
                return .localized(subtitle)
            }()
        )
        
        showSpinner(for: type, delay: delay)
    }
    
    /// Displays heads-up display for waiting period.
    ///
    /// - Parameters:
    ///   - success: Text to display for the spinner.
    ///   - subtitle: Text to display for the spinner subtitle.
    ///   - delay: Amount of time to display the spinner.
    func display(success: Localizable, subtitle: Localizable? = nil, delay: TimeInterval = 1.5) {
        let type: HUDContentType = .labeledSuccess(
            title: .localized(success),
            subtitle: {
                guard let subtitle = subtitle else { return nil }
                return .localized(subtitle)
            }()
        )
        
        showSpinner(for: type, delay: delay)
    }
    
    /// Displays heads-up display for waiting period.
    ///
    /// - Parameters:
    ///   - error: Text to display for the spinner.
    ///   - subtitle: Text to display for the spinner subtitle.
    ///   - delay: Amount of time to display the spinner.
    func display(error: Localizable, subtitle: Localizable? = nil, delay: TimeInterval = 3) {
        let type: HUDContentType = .labeledError(
            title: .localized(error),
            subtitle: {
                guard let subtitle = subtitle else { return nil }
                return .localized(subtitle)
            }()
        )
        
        showSpinner(for: type, delay: delay)
    }
}
