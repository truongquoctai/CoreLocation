//
//  SplashViewController.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

import MGArchitecture
import Reusable
import RxCocoa
import RxSwift
import Then
import UIKit

final class SplashViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: SplashViewModel!
    let loadTrigger = PublishSubject<Void>()
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    deinit {
        logDeinit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.shared.request()
        LocationManager.shared.setOnDidChangeAuthorization { [weak self] (_) in
            guard let self = self else { return }
            self.loadTrigger.onNext(())
        }
    }
    
    // MARK: - Methods

    private func configView() {
        
    }

    func bindViewModel() {
        let input = SplashViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete())
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: - Binders
extension SplashViewController {

}

// MARK: - StoryboardSceneBased
extension SplashViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.splash
}
