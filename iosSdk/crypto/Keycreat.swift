//
//  Keycreat.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import TrustWalletCore
class Keycreat{
    
    
    //private static let t = "1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec";
    
    //创建私钥
    static func CreatePrivateKey()-> String? {
        var privateKey:PrivateKey;
        
        repeat{
            privateKey = PrivateKey()
        }
         while !verifyKey(secretKey: privateKey.data.bytes.toHexString())
        
        return privateKey.data.bytes.toHexString()
    }
    
    //密钥验证
   static func verifyKey (secretKey:String) ->Bool{
        let t = "1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec";
        if secretKey.count != 64{
            // print("长度错误！")
               return false;
        }
        if secretKey.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue>0{
             //print("值小于。。。")
            return false ;
        }
      // print("正确！")
            return true;
    }
    
    //根据私钥得到公钥
    static func CreatePublicKey(privateKey:String)-> String? {
        let privateKey = PrivateKey(data: Data(hexString: privateKey)!)!
        let publicKey = privateKey.getPublicKeyEd25519()
        return publicKey.data.bytes.toHexString();
    }
    
    //签名
    static func Sign(msg:String,pri:String)-> String? {
        let message =  Data(hexString: msg)!
        let privateKey = PrivateKey(data: Data(hexString: pri)!)!
        let sign = privateKey.sign(digest: message, curve: .ed25519)!
        return sign.hexString;
    }

    
}
