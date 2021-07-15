//
//  SplashNavigator.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import UIKit

protocol SplashNavigatorType {
    func toMain()
}

struct SplashNavigator: SplashNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toMain() {
        let nvc = UINavigationController()
        let vc: MainViewController = assembler.resolve(navigationController: nvc)
        nvc.viewControllers.append(vc)
        window.rootViewController = nvc
        window.makeKeyAndVisible()
    }
}
