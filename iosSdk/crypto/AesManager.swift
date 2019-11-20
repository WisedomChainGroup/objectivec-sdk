//
//  AesManager.swift
//  
//
//  Created by peach on 2019/11/7.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import CryptoSwift
 class AesManager{
    
    
    //加密
    static func encrypt(content:String,keys:String,rmv:String) -> String? {
       
        
        
        let data1=Data(hexString: content)!
        let str1 = [UInt8](data1)
       
        let data2=Data(hexString: keys)!
        let bytes = [UInt8](data2)
        
        let ivs = Data(hexString: rmv)!
        let iv = [UInt8](ivs)
        
        let aes = try? AES(key: bytes, blockMode: CTR(iv: iv), padding: .noPadding)
        do {
            
            let enstr = try   aes!.encrypt(str1).toHexString()  //加密后：23d883cbb361bcacb1af1a3d8ea39d75c254f52d1948628853bdfb296a53a187
            return enstr
            
        } catch VendingMachineError.invalidSelection {
            // print("Invalid Selection.")
            return "-1"
        } catch VendingMachineError.outOfStock {
            //print("Out of Stock.")
            return "-2"
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            //print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
            return "-3"
        } catch {
            
        }
        return "0";
    }
    
    
    //解密
    static func dencrypt(content:String,keys:String,rmv:String)->String{
        
        //解密
        // let str = "23d883cbb361bcacb1af1a3d8ea39d75c254f52d1948628853bdfb296a53a187"
        let data1=Data(hexString: content)!
        let str1 = [UInt8](data1)
       
        let data2=Data(hexString: keys)!
        let bytes = [UInt8](data2)
      
        let ivs = Data(hexString: rmv)!
        let iv = [UInt8](ivs)
        
        let aes = try? AES(key: bytes, blockMode: CTR(iv: iv), padding: .noPadding)
        
        do {
            
            let denstr = try   aes!.decrypt(str1).toHexString()
            return denstr
            
        } catch VendingMachineError.invalidSelection {
            //print("Invalid Selection.")
            return "-1"
        } catch VendingMachineError.outOfStock {
            //print("Out of Stock.")
            return "-2"
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            //print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
            return "-3"
        } catch {
            
        }
        return "0";
        
        
    }
    
}
