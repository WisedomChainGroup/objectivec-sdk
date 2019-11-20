//
//  TradeUtility.swift
//  
//
//  Created by peach on 2019/11/18.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation
import UIKit

import TrustWalletCore
import CryptoSwift
import SwiftyJSON

@objc class TradeUtility:NSObject{
    
    
    //转账事务
    @objc func  ClientToTransferAccount(fromPubkeyStr:String,toPubkeyHashStr:String,amount:String,prikeyStr:String,nonce:UInt64)->String{
       do {
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
        
            //版本号
            let version="01";
            //类型：WDC转账
            let type="01";
        
            let _nonece = UInt64(bigEndian: nonce+1)
        
           // let gasPrice;
            let gasPrice = 100000000 + 0.002
        
           // let Amount = 1000000000 + amount;
        
            let signull = Utils.randomStr(len: 64)
            //长度
            let allPayload = "00000000";
        
         //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
        
        
            return ""

       }catch {
        
          return ""
       
        }
    }
    
    
    static func mul(amount:String)->String{
        //var arr = amount.split(".");
        var arr : Array = amount.components(separatedBy: ".")
        var newAmount:String = "0";
        if(arr.count>1){
            if(arr[1].count>8){
                return "-1";
            }
            var len:Int = arr[1].count;
            var decimal:String = arr[1];
            for i in 0 ..< (8-len){
               decimal = decimal+"0"
            }
           newAmount = arr[0]+decimal
        }else{
           newAmount = amount+"00000000"
        }
        return newAmount;
    }

    
    /**
     * 计算gas单价
     * @param gas
     * @param total
     * @return
     */
    static func obtainServiceCharge( gas:String, total:String)->CLongLong{
        
        let gaslong = NSString(string:gas).longLongValue
        let totallong = NSString(string: total).longLongValue
        return gaslong/totallong
    }
    
    static func checkNum(str: String)->String {
        // 使用正则表达式一定要加try语句
        do {
           
            // - 1、创建规则
            let pattern = "(^-?[0-9.]+$)"
            
            if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: str) {
                
              return str
                
            }else{
                return "-1";
            }
         
           
        }
        catch {
         
           return error.localizedDescription
        }
    }




}
