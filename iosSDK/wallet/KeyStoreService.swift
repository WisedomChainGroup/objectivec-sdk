//
//  KeyStoreService.swift
//  Created by peach on 2019/11/15.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//
import Foundation
import SwiftyJSON
import TrustWalletCore
//import CryptoSwift

@objc open class KeyStoreService:NSObject{
    /**
     通过keyStore和密码获取私钥
    **/
  @objc public static func getprivateKey(keyJson:String,password:String) -> String {
    
        let jsonData = keyJson.data(using: .utf8)
        //验证mac是否一致
        if !verifyPassword(keyJson: keyJson, passWord: password) {
             return ""
        }
        let json=JSON(jsonData)
        if let salt = json["kdfparams"]["salt"].string{
           // let salts = String(data: Data(hexString:salt)!, encoding: String.Encoding.utf8)!
            let derivedKey = ArgonManage.argon2id(password: password, salt: salt)
            let iv = json["crypto"]["cipherparams"]["iv"].string!
            if  let cipherPrivKey = json["crypto"]["ciphertext"].string{
                let cipherPrivKey = AesManager.dencrypt(content: derivedKey!, keys: cipherPrivKey, rmv: iv)
                //print("cipherPrivKey:===\(cipherPrivKey)")
                return cipherPrivKey;
            }else{
                return ""
            }
            
        }
        return "";
    }
    
    /**
     通过私钥获取公钥
    **/
@objc public  static  func privateKeyToPublicKey(privateKey:String) -> String {
    
        /*if !Keycreat.verifyKey(secretKey: privateKey) {
            return ""
        }*/
        return  Keycreat.CreatePublicKey(privateKey: privateKey)! ;
    }
    
    /**
     通过keyStore 验证密码是否正确   计算 mac
    **/
@objc public static   func verifyPassword(keyJson:String,passWord:String) ->Bool {
        let jsonData = keyJson.data(using: .utf8)
        let json=JSON(jsonData)
        if let salt = json["kdfparams"]["salt"].string{
           // print("salt:====\(salt)")
           // let salts = String(data: Data(hexString:salt)!, encoding: String.Encoding.utf8)!
            //print("salts:====\(salts)")
            let derivedKey = ArgonManage.argon2id(password: passWord, salt: salt) //e77c1e3ab4aa49a778f564c099d1cec68692a4752f62bb1584d713f544c5489c
           // print("derivedKey===\(derivedKey!)")
            if  let cipherPrivKey = json["crypto"]["ciphertext"].string{
              //   print("cipherPrivKey===\(cipherPrivKey)")
                let macData=Data(hexString:derivedKey!+cipherPrivKey)
                let mac = Hash.keccak256(data:macData! ).toHexString()
              //  print("mac===:\(mac)")
                let ksMac = json["mac"].stringValue
              //  print("ksMac===:\(ksMac)")
                if ksMac.caseInsensitiveCompare(mac as String).rawValue==0{
                    
                    return true
                }else{
                    return false
                }
            }else{
               return false
            }
        }else {
            return false
        }
       
    }
}
