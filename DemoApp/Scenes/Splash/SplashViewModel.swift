//
//  SplashViewModel.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct SplashViewModel {
    let navigator: SplashNavigatorType
    let useCase: SplashUseCaseType
}

// MARK: - ViewModel
extension SplashViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {

    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let threeSecondsTrigger = PublishSubject<Void>()
        Driver.combineLatest(input.loadTrigger, threeSecondsTrigger.asDriverOnErrorJustComplete())
            .asObservable()
            .take(1)
            .subscribe( onNext: { _ in
                navigator.toMain()
            })
            .disposed(by: disposeBag)
        
        after(interval: 3) {
            threeSecondsTrigger.onNext(())
        }
        return output
    }
}
