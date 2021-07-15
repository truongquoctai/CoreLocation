//
//  AppViewModel.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import MGArchitecture
import RxCocoa
import RxSwift

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModel
extension AppViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {

    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        input.loadTrigger
            .drive( onNext: {
                navigator.toSplash()
            })
            .disposed(by: disposeBag)
        return Output()
    }
}
