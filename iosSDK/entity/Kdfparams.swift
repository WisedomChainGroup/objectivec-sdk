//
//  Kdfparams.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import HandyJSON
 class Kdfparams:HandyJSON{
    
    var memoryCost:Int?;
    var timeCost:Int?;
     var parallelism:Int?;
     var salt:String?;
    
    required init() {
        
    }
    
}
