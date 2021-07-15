//
//  MainViewModel.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct MainViewModel {
    let navigator: MainNavigatorType
    let useCase: MainUseCaseType
}

// MARK: - ViewModel
extension MainViewModel: ViewModel {
    struct Input {

    }

    struct Output {

    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        return output
    }
}