//
//  WalletUtility.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import TrustWalletCore
import CryptoSwift
import SwiftyJSON
@objc class WalletUtility:NSObject {
    
    //生成keystore 根据密码生成keystore
    @objc func createKeyStoreFromPassword(password:String)-> String{
        
        if password.count > 20 {
            //throw VendingMachineError.outOfStock
            return "password is too long"
        }else if password.count < 6 {
            //throw VendingMachineError.outOfStock
            return "password is too short"
        }else{
           
          
            //1.通过通过Ed25519 生成秘钥对
           // let keycreate=Keycreat()
            let privateKey = Keycreat.CreatePrivateKey()!//得到私钥
         
            let publicKey = Keycreat.CreatePublicKey(privateKey: privateKey)! //得到公钥
            
          
            //2.通过argon2id加密密码
          
            let salt = Utils.randomStr(len: 32)//uni.random(32, true) //AES.randomIV(32).toHexString() //UUID().uuidString
            let derivedKey = ArgonManage.argon2id(password: password, salt: salt)
           //3.AES对derivedKey，privateKey 进行对称加密
           
            let iv =  AES.randomIV(16).toHexString()  //NSMutableData(length: 16)
          
            
            let cipherPrivKey = AesManager.encrypt(content: privateKey, keys: derivedKey!, rmv: iv) //ase.encryptString(
            //mac   byte[]合并
            //+cipherPrivKey
            let macData=Data(hexString:derivedKey!+cipherPrivKey!)
            let mac = Hash.keccak256(data:macData! )
            
            //cipherparams
            //获取得到地址  addressAccountUtility
            let publicHash = AccountUtility.publicKeyToPublicKeyHash(publicKey: publicKey)
            let address=AccountUtility.publickeyHashToAddress(pubkeyHash: publicHash!)!
        
            let keystore = KeysEntity()
            //address: address, crypto: crypto, id: UUID().uuidString, version: "1", mac: mac.toHexString(), kdf:"argon2id",kdfparams: kdfparams
            keystore.address=address
            keystore.id=UUID().uuidString
            keystore.kdf = "argon2id"
            keystore.mac = mac.toHexString()
            keystore.kdfparams = ["memoryCost":20480, "timeCost": 4,"parallelism":2,"salt":salt.bytes.toHexString()]
            keystore.crypto = ["cipher": "aes-256-ctr", "ciphertext": cipherPrivKey!,"cipherparams":["iv":iv]]
            keystore.version = "1"
            print(keystore.toJSONString()!)
            return keystore.toJSONString()!
        
        }
    
    }
    
    //通过keystore获取钱包地址
    @objc func keyStoreToAddress(keyJson:String,password:String)->String{
        
        if let keysData = keyJson.data(using: .utf8){
            let json=JSON(keysData)
            if let address = json["address"].string{
                 return address
            }else{
                return ""
            }
        }
        return "";
    }
    

    /**
       通过keystore获取公钥
    */
    @objc func keyStoreToPubKey(keyJson:String,password:String)->String{
        
        
        // print("---")
         if let jsonData = keyJson.data(using: .utf8){
            //1.查询私钥
            let privateKey = KeyStoreService.getprivateKey(keysData: jsonData, password: password)
            print(privateKey)
            if privateKey.count>1{
                //2.查询公钥
                 let pubString = KeyStoreService.privateKeyToPublicKey(privateKey: privateKey)
                // print(pubString)
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
    @objc func keyStoreToPubKeyHash(keyJson:String,password:String)->String{
        
        
        if let jsonData = keyJson.data(using: .utf8){
            //1.查询私钥
            let privateKey = KeyStoreService.getprivateKey(keysData: jsonData, password: password)
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
