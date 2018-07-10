//
//  ScrollableFlowLayout.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-28.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

protocol ScrollableFlowLayout {
    func willBeginDragging()
    func willEndDragging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}
