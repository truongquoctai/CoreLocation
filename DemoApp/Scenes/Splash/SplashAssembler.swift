//
//  SplashAssembler.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import Reusable
import UIKit

protocol SplashAssembler {
    func resolve(window: UIWindow) -> SplashViewController
    func resolve(window: UIWindow) -> SplashViewModel
    func resolve(window: UIWindow) -> SplashNavigatorType
    func resolve() -> SplashUseCaseType
}

extension SplashAssembler {
    func resolve(window: UIWindow) -> SplashViewController {
        let vc = SplashViewController.instantiate()
        let vm: SplashViewModel = resolve(window: window)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(window: UIWindow) -> SplashViewModel {
        return SplashViewModel(
            navigator: resolve(window: window),
            useCase: resolve()
        )
    }
}

extension SplashAssembler where Self: DefaultAssembler {
    func resolve(window: UIWindow) -> SplashNavigatorType {
        return SplashNavigator(assembler: self, window: window)
    }

    func resolve() -> SplashUseCaseType {
        return SplashUseCase()
    }
}