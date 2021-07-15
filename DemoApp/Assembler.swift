//
//  Assembler.swift
//  DemoApp
//
//  Created by Truong Quoc Tai on 5/28/21.
//  Copyright © 2021 TaiTQ. All rights reserved.
//

protocol Assembler: class,
    GatewaysAssembler,
    AppAssembler,
    SplashAssembler,
    MainAssembler,
    HomeAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
