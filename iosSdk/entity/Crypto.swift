//
//  Crypto.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import HandyJSON

class Crypto:HandyJSON{
     var cipher:String?;
     var ciphertext:String?;
     var  cipherparams:[Cipherparams]?;
    
    required init() {
      
    }
}
