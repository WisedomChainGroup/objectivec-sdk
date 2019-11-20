//
//  Keystore.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import HandyJSON
class KeysEntity : HandyJSON{
    
    var address:String!
    var crypto: Dictionary<String, Any> = [:]
    var kdfparams: Dictionary<String, Any> = [:]
    var id:String!
    var version:String!
    var mac:String!
    var kdf:String!
    
    //static var saltLength = 32;
    //static var ivLength = 16;
    //static var defaultVersion = "1";
  /*init(address:String,crypto:Crypto,id:String,version:String,mac:String,kdf:String,kdfparams:Kdfparams) {
        self.address=address
        self.crypto=crypto
        self.kdfparams=kdfparams
        self.id=id
        self.version=version
        self.mac=mac
        self.kdf=kdf
    }*/
    required init() {
        
    }
    
}
