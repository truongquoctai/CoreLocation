//
//  MainViewController.swift
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
import CoreLocation

final class MainViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    
    @IBOutlet weak var btnUpdateLocation: UIButton!
    @IBOutlet weak var lblUpdateLongitude: UILabel!
    @IBOutlet weak var lblUpdateLatitude: UILabel!
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnLocationFromAddress: UIButton!
    @IBOutlet weak var lblLongitudeLFA: UILabel!
    @IBOutlet weak var lblLatitudeLFA: UILabel!
    
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var btnAddressFromLocation: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    
    // MARK: - Properties
    
    var viewModel: MainViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        btnCurrentLocation.rx.tap
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] in
                if let currentLocation = LocationManager.shared.getCurrentLocation() {
                    self?.lblLongitude.text = "\(currentLocation.coordinate.longitude)"
                    self?.lblLatitude.text = "\(currentLocation.coordinate.latitude)"
                }
            })
            .disposed(by: disposeBag)
        
        btnUpdateLocation.tag = 1
        btnUpdateLocation.rx.tap
                    .asDriverOnErrorJustComplete()
                    .drive(onNext:{[weak self] in
                        guard let self = self else { return }
                        let status = LocationManager.shared.getAuthorizationStatus()
                        if status == .denied || status == .restricted || status == .notDetermined || !CLLocationManager.locationServicesEnabled() {
                            LocationManager.shared.showAlertGotoSettings()
                            return
                        }
                        
                        if self.btnUpdateLocation.tag == 1 {
                            self.btnUpdateLocation.tag = 2
                            self.btnUpdateLocation.setTitle("Stop Update Location", for: .normal)
                            LocationManager.shared.startUpdatingLocation { (location) in
                                self.lblUpdateLongitude.text = "\(location.coordinate.longitude)"
                                self.lblUpdateLatitude.text = "\(location.coordinate.latitude)"
                                print("Location: \(location.coordinate.longitude) | \(location.coordinate.latitude)")
                            }
                        } else {
                            self.btnUpdateLocation.tag = 1
                            self.btnUpdateLocation.setTitle("Start Update Location", for: .normal)
                            LocationManager.shared.stopUpdatingLocation()
                        }
                        
                    })
                    .disposed(by: disposeBag)
        
        
        btnLocationFromAddress.rx.tap
            .asDriverOnErrorJustComplete()
            .debounce(.milliseconds(500))
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                if let address = self.txtAddress.text, !address.isEmpty {
                    LocationManager.shared.getLocation(from: address) { [weak self](location) in
                        guard let self = self else { return }
                        if let location  = location {
                            self.lblLongitudeLFA.text = "\(location.longitude)"
                            self.lblLatitudeLFA.text = "\(location.latitude)"
                        } else {
                            self.lblLongitudeLFA.text = ""
                            self.lblLatitudeLFA.text = ""
                            self.showError(message: "Địa chỉ bạn nhập vào không đúng!")
                        }
                    }
                } else {
                    self.showError(message: "Địa chỉ bạn nhập vào không đúng!")
                }
            })
            .disposed(by: disposeBag)
        
        btnAddressFromLocation.rx.tap
            .asDriverOnErrorJustComplete()
            .debounce(.milliseconds(500))
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                if let lat = Double(self.txtLatitude.text ?? ""),
                   let long = Double(self.txtLongitude.text ?? "") {
                    LocationManager.shared.getAddressFromLocation(latitude: lat, longitude: long) { (address, error) in
                        if error != nil {
                            self.showError(message: error?.localizedDescription ?? "")
                        } else if let address = address {
                            self.lblAddress.text = address
                        }
                    }
                } else {
                    self.showError(message: "Vị trí bạn nhập vào không đúng!")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: - Binders
extension MainViewController {
    
}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
