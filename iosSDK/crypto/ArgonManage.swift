//
//  ArgonManage.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import CatCrypto

class ArgonManage{
    
   static func argon2id(password:String,salt:String)->String?{
        let hexpasswd = salt+password
        
       // let salts = Data(hexString:salt)
        //print("salt==="+salt)
        //print("passwdHex==="+password.bytes.toHexString())
        //print("hexpasswd===="+hexpasswd)
        //c3381bbaeeb7e63b2846ce3ad1dce4bb0dd19909736e79eeeac85fbdf7da16eb313233343536373839
        //c3381bbaeeb7e63b2846ce3ad1dce4bb0dd19909736e79eeeac85fbdf7da16eb313233343536373839
      
        let argon2Crypto = CatArgon2Crypto()
        argon2Crypto.context.salt = salt//"00000000000000000000000000000000"
        argon2Crypto.context.mode = .argon2id
        argon2Crypto.context.memory=20480
        argon2Crypto.context.parallelism=2
        argon2Crypto.context.iterations=4
        argon2Crypto.context.hashResultType = .hashRaw
        
        let argon=argon2Crypto.hash(password: hexpasswd)
      
        // print(UUID().uuidString)
        //print(argon)//8118c2f88eeb5b02df1e75b26c49e9c87e2109d1e0ecb409dd7361c34367ee80
        return argon.hexStringValue()
    }
}
