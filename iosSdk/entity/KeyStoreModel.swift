//
//  KeyStoreModel.swift
//  
//
//  Created by peach on 2019/11/15.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import HandyJSON

class KeyStoreModel:HandyJSON{

    var address:String?
    var crypto: [Crypto]?
    var kdfparams: [Kdfparams]?
    var id:String?
    var version:String?
    var mac:String?
    var kdf:String?

    required init() {
       
    }
}
