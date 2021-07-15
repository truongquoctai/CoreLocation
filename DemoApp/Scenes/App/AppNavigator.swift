//
//  AppNavigator.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import UIKit

protocol AppNavigatorType {
    func toSplash()
}

struct AppNavigator: AppNavigatorType {
    
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toSplash() {
        let splashViewController: SplashViewController = assembler.resolve(window: window)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}
