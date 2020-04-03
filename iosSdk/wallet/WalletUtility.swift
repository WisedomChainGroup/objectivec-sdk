//
//  WalletUtility.swift
//
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import TrustWalletCore
//import CryptoSwift
import SwiftyJSON
@objc open class WalletUtility:NSObject {
    
    //生成keystore 根据密码生成keystore
    @objc public  static  func createKeyStoreFromPassword(password:String,prefix:String)-> String{
        
        if password.count > 20 {
            //throw VendingMachineError.outOfStock
            return "password is too long"
        }else if password.count < 6 {
            //throw VendingMachineError.outOfStock
            return "password is too short"
        }else{
            
            let pre:String;
            if prefix == "" || prefix.isEmpty{
                pre = "WX"
            }else{
                pre = prefix
            }
            //1.通过通过Ed25519 生成秘钥对
           // let keycreate=Keycreat()
            let privateKey = Keycreat.CreatePrivateKey()!//得到私钥
            print("privateKey+++++++++++\(privateKey)")
            let publicKey = Keycreat.CreatePublicKey(privateKey: privateKey)! //得到公钥
            print("publicKey+++++++++++\(publicKey)")
          
            //2.通过argon2id加密密码
          
            let salt = Utils.randomStr(len: 32).bytes.toHexString()//uni.random(32, true) //AES.randomIV(32).toHexString() //UUID().uuidString
            let derivedKey = ArgonManage.argon2id(password: password, salt: salt)
           //3.AES对derivedKey，privateKey 进行对称加密
           
            let iv = Cryptors.randomIV(16).toHexString() //AES.randomIV(16).toHexString()  //NSMutableData(length: 16)
          
            
            let cipherPrivKey = AesManager.encrypt(content: privateKey, keys: derivedKey!, rmv: iv) //ase.encryptString(
            //mac   byte[]合并
            //+cipherPrivKey
            let macData=Data(hexString:derivedKey!+cipherPrivKey!)
            let mac = Hash.keccak256(data:macData! )
            
            //cipherparams
            //获取得到地址  addressAccountUtility
            let publicHash = AccountUtility.publicKeyToPublicKeyHash(publicKey: publicKey)
            //print("publicHash+++++++++++\(publicHash)")
            let address = AccountUtility.publickeyHashToAddress(pubkeyHash: publicHash!, prefix:pre)!
            // print("address+++++++++++\(address)")
            let keystore = KeysEntity()
            //address: address, crypto: crypto, id: UUID().uuidString, version: "1", mac: mac.toHexString(), kdf:"argon2id",kdfparams: kdfparams
            keystore.address=address
            keystore.id=UUID().uuidString
            keystore.kdf = "argon2id"
            keystore.mac = mac.toHexString()
            keystore.kdfparams = ["memoryCost":20480, "timeCost": 4,"parallelism":2,"salt":salt]
            keystore.crypto = ["cipher": "aes-256-ctr", "ciphertext": cipherPrivKey!,"cipherparams":["iv":iv]]
            keystore.version = "2"
          
            //print("keystore.toJSONString()!============\(keystore.toJSONString()!)")
            return keystore.toJSONString()!
        
        }
    
    }
    
    //通过keystore获取钱包地址
    @objc public static func keyStoreToAddress(keyJson:String,password:String)->String{
     if WalletUtility.isjsonStyle(txt: keyJson) == true {
         if let keysData = keyJson.data(using: .utf8){
 
            let json=JSON(keysData)
            if let address = json["address"].string{
                 return address
            }else{
                return ""
            }
         }
     }
        return "";
    }
    
  @objc public static func isjsonStyle(txt:String) -> Bool {
        let jsondata = txt.data(using: .utf8)
        do {
            try JSONSerialization.jsonObject(with: jsondata!, options: .mutableContainers)
            return true
        } catch {
            return false
        }
        
    }

    /**
       通过keystore获取公钥
    */
    @objc public static func keyStoreToPubKey(keyJson:String,password:String)->String{
        
         if let jsonData = keyJson.data(using: .utf8){
            
            let json=JSON(jsonData)
            let version = json["version"].string!
            if version == "1" {
                return "1"
            }
            //1.查询私钥
            let privateKey = KeyStoreService.getprivateKey(keyJson: keyJson, password: password)
         //  print("privateKey====\(privateKey)")
            if privateKey.count>1{
                //2.查询公钥
                 let pubString = KeyStoreService.privateKeyToPublicKey(privateKey: privateKey)
               //  print("pubString===\(pubString)")
                 return pubString
            }
            
         }else{
            return ""
        }
        
       return ""
        
    }
    
    /**
     通过keystore获取公钥Hash
     */
    @objc public static func keyStoreToPubKeyHash(keyJson:String,password:String)->String{
        
        
        if let jsonData = keyJson.data(using: .utf8){
            //1.查询私钥
            let privateKey = KeyStoreService.getprivateKey(keyJson: keyJson, password: password)
            if privateKey.count>1{
                //2.查询公钥
                let pubString = KeyStoreService.privateKeyToPublicKey(privateKey: privateKey)
                let pubkeyHash = AccountUtility.publicKeyToPublicKeyHash(publicKey: pubString)!
                return pubkeyHash
            }
            
        }else{
            return ""
        }
        
        return ""
        
    }
    
    
    
}

