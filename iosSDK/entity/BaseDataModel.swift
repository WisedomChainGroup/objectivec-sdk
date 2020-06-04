//
//  BaseDataModel.swift
//  
//
//  Created by peach on 2019/11/15.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import  UIKit
import  HandyJSON

class BaseDataModel:HandyJSON{
    
    var code:NSInteger?
    var Data:[KeyStoreModel]?
    var message:String?
    
    required init() {
       
    }
    
}
