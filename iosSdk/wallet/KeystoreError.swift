//
//  KeystoreError.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation

@objc class KeystoreError:NSObject{
    
}


enum VendingMachineError: Error {
    case invalidSelection                     //选择无效
    case insufficientFunds(coinsNeeded: Int) //金额不足
    case outOfStock                             //缺货
}
