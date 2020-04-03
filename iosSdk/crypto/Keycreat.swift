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
        if secretKey.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue<0{
            // print("值小于。。。")
            return false ;
        }
      //print("正确！")
            return true;
    }
    
    //根据私钥得到公钥
    static func CreatePublicKey(privateKey:String)-> String? {
        var pri:String = privateKey ;
        if privateKey.count == 128{
            pri = String(privateKey.prefix(64))
        }
        let privateKeys = PrivateKey(data: Data(hexString: pri)!)!
        let publicKey = privateKeys.getPublicKeyEd25519()
        return publicKey.data.bytes.toHexString();
    }
    
    //签名
    static func Sign(msg:String,pri:String)-> String? {
        let message =  Data(hexString: msg)!
        let privateKey = PrivateKey(data: Data(hexString: pri)!)!
        let sign = privateKey.sign(digest: message, curve: .ed25519)!
        return sign.hexString;
    }
    
    //验证签名
    static func VerifySign(signStr:String,pubStr:String,msgStr:String)-> String? {
        let message =  Data(hexString: msgStr)!
        let sign =  Data(hexString: signStr)!
        let pubStrData =  Data(hexString: pubStr)!
        
        if pubStr.count != 64{
               return "0";
        }
        
        let publicKey = PublicKey(data: pubStrData, type: .ed25519)!
        let verified = publicKey.verify(signature: sign, message: message)
      
        if verified {
            return "1"
        }else
        {
            return "0"
        }
        
    }
    
}
