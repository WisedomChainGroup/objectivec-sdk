//
//  AccountUtility.swift
//  
//
//  Created by peach on 2019/11/8.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import TrustWalletCore
//import CryptoSwift

@objc open class AccountUtility:NSObject {
    
    
    
    /*
     * 地址生成逻辑
     1.对公钥进行SHA3-256哈希，再进行RIPEMD-160哈希， 得到哈希值r1
     2.在r1前面附加一个字节的版本号:0x01* 得到结果r2
     3.将r1进行两次SHA3-256计算，得到结果r3， 获得r3的前面4个字节，称之为b4
     4.将b4附加在r2的后面，得到结果r5
     5.将r5进行base58编码，得到结果r6
     6.r6就是地址
     */
    @objc public  static func publickeyHashToAddress(pubkeyHash:String,prefix:String)->String?{
        
        //print("publicHsh=="+pubkeyHash)
        let r1 = Data(hexString: pubkeyHash)!; //pubkeyHash.bytes.toHexString()
        // let v1 = Data(hexString: "0X00")!
        let r2 = "00"+r1.toHexString()
        //print("r2=====")
        // print(r2)
        // let t=Hash.keccak256(data: r1)
        // print("t======")
        // print(t.toHexString())
        
        let r3 = Hash.keccak256(data:Hash.keccak256(data: r1))
        
        let b4 = r3.toHexString()
        // print("b4==="+b4)
        let index = b4.index(b4.startIndex, offsetBy: 8)
        let r4 = b4.prefix(upTo: index)
        // print("r4==="+r4)
        let r5 =  Data(hexString:r2+r4)!
        //print("r5===="+r5.toHexString())  //0000e9dfbeb7887ca5a16859c162d50457be2910f069c37b86
        //0000e9dfbeb7887ca5a16859c162d50457be2910f069c37b86
        let r6 = Base58.encodeNoCheck(data:r5)
        //  print("r6==="+r6)
        return  prefix+r6
        
    }
    
    
    
    /**
     * 地址转公钥哈希
     1.将地址进行base58解码，得到结果r5
     2.将r5移除后后面4个字节得到r2
     3.将r2移除第1个字节:0x01得到r1(公钥哈希值)
     * @param address
     * @return
     */
    @objc public static func  addressToPubkeyHash( address:String)->String?{
        
        let b5:String;
        if address.prefix(1)=="1" {
            let  r5 = Base58.decodeNoCheck(string: address)
            b5 = r5!.toHexString()
        }else{
            let indexs = address.index(address.startIndex, offsetBy: address.count-(address.count-2))
            let subaddress:String = String(address.suffix(from: indexs))
            
            let r5 = Base58.decodeNoCheck(string: subaddress)
            b5 = r5!.toHexString()
        }
        //let r5 = Base58.decodeNoCheck(string: address)
        //let b5=r5!.toHexString()
        
        //print("r5===")
        //print(b5)
        let index = b5.index(b5.startIndex, offsetBy: b5.count-8)
        let r2 = b5.prefix(upTo: index)
        // print("r2==="+r2)
        
        let count = r2.count-2
        let index1 = r2.index(r2.endIndex, offsetBy: -count)
        let publickeyHash = r2.substring(from: index1)
        // print("publickeyHash==="+publickeyHash)
        
        return publickeyHash;
    }
    
    /**
     公钥转公钥hash
     */
    @objc public static func publicKeyToPublicKeyHash(publicKey:String)->String?{
        
        let pubkey    = Data(hexString: publicKey)!
        let pub256 = Hash.keccak256(data:pubkey)
        let r1 = Hash.ripemd(data: pub256)
        let pubkeyHash = r1.hexString
        //print("pubkeyHash========"+pubkeyHash)
        return pubkeyHash;
    }
    
    /**
     事务哈希转公钥hash
     */
    @objc public static func affairHashToPublicKeyHash(affairHashStr:String)->String?{
        
        let pubkey    = Data(hexString: affairHashStr)!
        let r1 = Hash.ripemd(data: pubkey)
        let pubkeyHash = r1.hexString
        //print("pubkeyHash========"+pubkeyHash)
        return pubkeyHash;
    }
    
    /**
     地址正确性校验
     */
    @objc public static func verifyAddress(address:String) ->Int{
        
        
        if address.isEmpty {
            // print("isempty")
            return -1
            
        }
        if address.prefix(2) == "WX" || address.prefix(2) == "WR" {
            
            //b4 和_b4进行比较
            
            let b5:String;
            if address.prefix(1)=="1" {
                let  r5 = Base58.decodeNoCheck(string: address)
                b5 = r5!.toHexString()
            }else{
                let indexs = address.index(address.startIndex, offsetBy: address.count-(address.count-2))
                let subaddress:String = String(address.suffix(from: indexs))
                
                let r5 = Base58.decodeNoCheck(string: subaddress)
                b5 = r5!.toHexString()
            }
            
            // = r5!.toHexString()
            
            //print("b5====\(b5)")
            //print(b5)
            let index = b5.index(b5.startIndex, offsetBy: b5.count-8)
            let _b4 = b5.suffix(from: index)
            //  print("_b4====")
            //   print(_b4)
            
            let a =  Data(hexString:self.addressToPubkeyHash(address: address)!)
            let b = Hash.keccak256(data: a!)
            let r3 = Hash.keccak256(data: b)
            //  print("r3====")
            // print(r3.toHexString())
            let b4 = r3.toHexString().prefix(8)
            // print("b4====\(b4)")
            //print("_b4========\(_b4)")
            
            if(b4 == _b4){
                // print("ddddddddddddd")
                return 0;
            }else{
                //print("-2")
                return -2;
            }
        }else{
            //print("-1")
            return -1;
        }
        // print("5000")
        // return 5000;
        
    }
    
    
   
    
}
