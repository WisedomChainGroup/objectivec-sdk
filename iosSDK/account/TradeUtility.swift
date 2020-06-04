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
//import CryptoSwift
import SwiftyJSON

@objc open class TradeUtility:NSObject{
    
    static var RATE:String = "100000000"
    static var GAS:Int = 2  //手续费
    static var SIGNNULL:String = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    static var TONULL:String = "0000000000000000000000000000000000000000"
    
    
    
    /**
     * 构造交易事务(转账)  已完成
     * @param fromPubkeyStr    16进制
     * @param toPubkeyHashStr  16进制
     * @param amount
     * @param prikeyStr 私钥    16进制
     * @return
     */
    @objc public static func  ClientToTransferAccount(fromPubkeyStr:String,toPubkeyHashStr:String,prikeyStr:String ,amount:String,nonce:Int)->String{
        do {
            
   
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
            //版本号
            let version="01";
            //类型：WDC转账
            let type="01";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS+2).intToEightBytes()
            
            let num =  NSDecimalNumber(string: amount)   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let t = "1"
            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
                return "5000"
            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            let allPayload = "00000000";
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
            
            print("RawTransactionStr=====\(RawTransactionStr)");
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload //version.bytes.toHexString()+type.bytes.toHexString()+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload.bytes.toHexString()
            
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
            
            
        }catch {
            return "5000"
        }
    }
    
   
    
    
    /**
     * 构造签名的投票事务
     * @param fromPubkeyStr   16进制
     * @param toPubkeyHashStr 16进制
     * @param amount
     * @param nonce
     * @param prikeyStr （私钥）16进制
     * @return
     */
    @objc public static func ClientToTransferVote(fromPubkeyStr:String,  toPubkeyHashStr:String,  amount:String,  prikeyStr:String,nonce:Int)->String{
        
        
        do {
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
            //版本号
            let version="01";
            //类型：WDC投票事务
            let type="02";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS*5).intToEightBytes()
            
            let num =  NSDecimalNumber(string: amount)   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let t = "1"
            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
                return "5000"
            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            let allPayload = "00000000";
            //长度
            //let txidl = Data(hexString: txid)
            // let payloadLen = txidl!.count.hw_to4Bytes()
            
            //let payloadLen = txid.count.hw_to4Bytes()
            // print("payloadLen======\(payloadLen)")
            // let payload = txidl!.bytes.toHexString()
            //let allPayload = payloadLen.toHexString() + txid
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
            
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload //version.bytes.toHexString()+type.bytes.toHexString()+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload.bytes.toHexString()
            
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
            
            
        }catch {
            return "5000"
        }
        
    }
    
    
    /**
     * 构造投票撤回事务
     * @param fromPubkeyStr  16进制
     * @param toPubkeyHashStr 16进制
     * @param amount
     * @param nonce
     * @param txid
     * @param prikeyStr （私钥）16进制
     * @return
     */
    
    @objc public static func ClientToTransferVoteWithdraw(fromPubkeyStr:String,  toPubkeyHashStr:String,  amount:String,  prikeyStr:String,nonce:Int,txid:String)->String{
        
        
        do {
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
            //版本号
            let version="01";
            //类型：WDC投票撤回事务
            let type="0d";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS*5).intToEightBytes()
            
            let num =  NSDecimalNumber(string: amount)   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let t = "1"
            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
                return "5000"
            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            //let allPayload = "00000000";
            //长度
            let txidl = Data(hexString: txid)
            let payloadLen = txidl!.count.hw_to4Bytes()
            
            //let payloadLen = txid.count.hw_to4Bytes()
            // print("payloadLen======\(payloadLen)")
            // let payload = txidl!.bytes.toHexString()
            let allPayload = payloadLen.toHexString() + txid
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
            
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
        }catch {
            return "5000"
        }
        
    }
    
    
    /**
     * 构造签名的抵押事务
     * @param fromPubkeyStr   16进制
     * @param toPubkeyHashStr  16进制
     * @param amount
     * @param nonce
     * @param prikeyStr   16进制
     * @return
     */
    @objc public static func ClientToTransferMortgage(fromPubkeyStr:String,  toPubkeyHashStr:String,  amount:String,  prikeyStr:String,nonce:Int)->String{
        
        
        do {
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
            //版本号
            let version="01";
            //类型：WDC投票事务
            let type="0e";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS*5).intToEightBytes()
            
            let num =  NSDecimalNumber(string: amount)   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let t = "1"
            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
                return "5000"
            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            let allPayload = "00000000";
            //长度
            //let txidl = Data(hexString: txid)
            // let payloadLen = txidl!.count.hw_to4Bytes()
            
            //let payloadLen = txid.count.hw_to4Bytes()
            // print("payloadLen======\(payloadLen)")
            // let payload = txidl!.bytes.toHexString()
            //let allPayload = payloadLen.toHexString() + txid
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
            
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload //version.bytes.toHexString()+type.bytes.toHexString()+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload.bytes.toHexString()
            
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
            
            
        }catch {
            return "5000"
        }
        
    }
    
    /**
     * 构造抵押撤回事务
     * @param fromPubkeyStr    16进制
     * @param toPubkeyHashStr  16进制
     * @param amount
     * @param nonce
     * @return
     */
    
    @objc public  static func ClientToTransferMortgageWithdraw(fromPubkeyStr:String,  toPubkeyHashStr:String,  amount:String,  prikeyStr:String,nonce:Int,txid:String)->String{
        
        
        do {
            let isNum =  TradeUtility.checkNum(str: amount)
            if(isNum == "-1"){
                return "5000";
            }
            //版本号
            let version="01";
            //类型：WDC投票撤回事务
            let type="0f";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS*5).intToEightBytes()
            
            let num =  NSDecimalNumber(string: amount)   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let t = "1"
            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
                return "5000"
            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            //let allPayload = "00000000";
            //长度
            let txidl = Data(hexString: txid)
            let payloadLen = txidl!.count.hw_to4Bytes()
            
            //let payloadLen = txid.count.hw_to4Bytes()
            // print("payloadLen======\(payloadLen)")
            // let payload = txidl!.bytes.toHexString()
            let allPayload = payloadLen.toHexString() + txid
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
            
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPubkeyHashStr+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
        }catch {
            return "5000"
        }
        
    }
    
    /**
     *构造存证事务
     * @param fromPubkeyStr 16进制
     * @param payloadbyte 16进制
     * @param prikeyStr 16进制
     * @return
     * @throws DecoderException
     */
    
    @objc  public static  func  ClientToTransferProve(fromPubkeyStr:String,  prikeyStr:String,nonce:Int,payloadbyte:String)->String{
        
        do {
            
            //版本号
            let version="01";
            //类型：WDC存证事务
            let type="03";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS).intToEightBytes()
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)
            //长度
            //let allPayload = "00000000";
            //长度
            let txidl = Data(hexString: payloadbyte)
            let payloadLen = txidl!.count.hw_to4Bytes()
            
            //let payloadLen = txid.count.hw_to4Bytes()
            // print("payloadLen======\(payloadLen)")
            // let payload = txidl!.bytes.toHexString()
            let allPayload = payloadLen.toHexString()+payloadbyte
            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+signull+allPayload
            
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            // let sigHex = sigall.index(sigall.startIndex, offsetBy: 128)
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+sigall+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+sigall+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
        }catch {
            return "5000"
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
        print(gaslong)
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
    
    
    
    /**
     * 构造发行事务
     * @param fromPubkeyStr    16进制
     * @param prikeyStr 私钥    16进制
     * @return
     */
    @objc public static func  CreateSignToDeployforRuleAsset(fromPubkeyStr:String,prikeyStr:String,nonce:Int,payloadData:Data)->String{
        do {
            
            
//            var stringArray = Array<String>()
//            stringArray.append("1")
//            stringArray.append("2")
//            stringArray.append("3")
            
//            let payloadData = try RLP.encode(payloadArr)
            let payloadDataStr = payloadData.toHexString()
            let payloadLen =  (payloadData.count + 1).hw_to4Bytes
            let allPayload = payloadLen().toHexString()+"00"+payloadDataStr

            
            //版本号
            let version="01";
            //类型：发行代币
            let type="07";
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS).intToEightBytes()
            
            let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
//            let t = "1"
//            if s.compare(t as String,options: NSString.CompareOptions.caseInsensitive).rawValue < 0{
//                return "5000"
//            }
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)

            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+TradeUtility.TONULL+allPayload
            
            print("RawTransactionStr=====\(RawTransactionStr)");
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+TradeUtility.TONULL+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+TradeUtility.TONULL+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
            
            
        }catch {
            return "5000"
        }
    }
    
    
    /**
         * 构造代币增发、所有权、转账事务
         * @param fromPubkeyStr    16进制
         * @param prikeyStr 私钥    16进制
         * @return
         */
        @objc public static func  CreateSignToDeployforRuleTransfer(fromPubkeyStr:String,prikeyStr:String,nonce:Int,payloadData:Data,typeStr:String,toPublicHash:String)->String{
            do {
                //增发、所有权、转账  typeStr--> 02 00 01
                let payloadDataStr = payloadData.toHexString()
                let payloadLen =  (payloadData.count + 1).hw_to4Bytes
                let allPayload = payloadLen().toHexString()+typeStr+payloadDataStr

                //版本号
                let version="01";
                //类型： 增发、所有权、转账
                let type="08";
                
                let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
                
                let gasPrice = (TradeUtility.GAS).intToEightBytes()
                
                let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
                let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
                let amountLong = Int(s)!.intToEightBytes() //无符号字节
                
                //为签名留白
                let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)

                
                //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
                let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPublicHash+allPayload
                
                print("RawTransactionStr=====\(RawTransactionStr)");
                //签名数据
                let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
                
                let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
                
                let transha = Data(hexString:tra)!
                
                let txHash = Hash.keccak256(data:transha)
                
                let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
                let apiModel = ApiResultEntity()
                
                apiModel.txHash = txHash.toHexString()
                apiModel.transaction = transaction
                
                return apiModel.toJSONString()!
                
            }catch {
                return "5000"
            }
        }
    
    
    
    /**
         * 构造多签部署原文
         * @param fromPubkeyStr    16进制
         * @param prikeyStr 私钥    16进制
         * @return
         */
        @objc public static func  ClientToCreateMultiSign(fromPubkeyStr:String,prikeyStr:String,nonce:Int,payloadData:Data)->String{
            do {

                let payloadDataStr = payloadData.toHexString()
                let payloadLen =  (payloadData.count + 1).hw_to4Bytes
                let allPayload = payloadLen().toHexString()+"01"+payloadDataStr

                //版本号
                let version="01";
                //类型：发行代币
                let type="07";
                
                let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
                
                let gasPrice = (TradeUtility.GAS).intToEightBytes()
                
                let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
                let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue

                let amountLong = Int(s)!.intToEightBytes() //无符号字节
                
                //为签名留白
                let signull = TradeUtility.SIGNNULL
                
                //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
                let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+TradeUtility.TONULL+allPayload
                
                return RawTransactionStr
                
            }catch {
                return "5000"
            }
        }
        
    
    
            /**
            * 对原文签名
            * @param message    string
            * @param prikeyStr 私钥    16进制
            * @return
            */
           @objc public static func  SignMultiSign(message:String,prikeyStr:String)->String{
               do {

                    //签名数据
                   let sigall = Keycreat.Sign(msg: message, pri: prikeyStr)!
                   return sigall
                   
               }catch {
                   return "5000"
               }
           }
    
            /**
            * 验证原文签名
            * @param message    string
            * @param prikeyStr 私钥    16进制
            * @return
            */
           @objc public static func  verifySign(message:String,pubKeyStr:String,signStr:String)->String{
               do {

                    //签名数据
                   let sigall = Keycreat.VerifySign(signStr: signStr, pubStr: pubKeyStr, msgStr: message)!
                   return sigall
                   
               }catch {
                   return "5000"
               }
           }
    
    
    /**
         * 构造多签转账原文
         * @param fromPubkeyStr    16进制
         * @param prikeyStr 私钥    16进制
         * @return
         */
        @objc public static func  ClientToCreateMultiSignTransfer(fromPubkeyStr:String,prikeyStr:String,nonce:Int,toPubkeyHashStr:String,payloadData:Data)->String{
            do {

                let payloadDataStr = payloadData.toHexString()
                let payloadLen =  (payloadData.count + 1).hw_to4Bytes
                let allPayload = payloadLen().toHexString()+"03"+payloadDataStr

                //版本号
                let version="01";
                //类型：发行代币
                let type="08";
                
                let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
                
                let gasPrice = (TradeUtility.GAS).intToEightBytes()
                
                let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
                let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue

                let amountLong = Int(s)!.intToEightBytes() //无符号字节
                
                //为签名留白
                let signull = TradeUtility.SIGNNULL
                
                //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
                let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPubkeyHashStr+allPayload
                
                return RawTransactionStr
                
            }catch {
                return "5000"
            }
        }
        
    
    
    /**
     * 构造多签发行代币及转账事务
     * @param fromPubkeyStr    16进制
     * @param prikeyStr 私钥    16进制
     * @return
     */
    @objc public static func  multiSignerAffair(type:String,nonce:Int,fromPubkeyStr:String,toPublicHash:String,prikeyStr:String,payloadType:String,payloadData:Data)->String{
        do {

            let payloadDataStr = payloadData.toHexString()
            let payloadLen =  (payloadData.count + 1).hw_to4Bytes
            let allPayload = payloadLen().toHexString()+payloadType+payloadDataStr

            //版本号
            let version="01";
            //类型：发行代币 转账
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS).intToEightBytes()
            
            let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)

            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPublicHash+allPayload
            
            print("RawTransactionStr=====\(RawTransactionStr)");
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
        }catch {
            return "5000"
        }
    }
    
    
    /**
     * 构造条件支付部署转入提取事务
     * @param fromPubkeyStr    16进制
     * @param prikeyStr 私钥    16进制
     * @return
     */
    @objc public static func  CreateRateheightlockruleForDeploy(type:String,nonce:Int,fromPubkeyStr:String,toPublicHash:String,prikeyStr:String,payloadType:String,payloadData:Data)->String{
        do {

            //部署 07 04   转入08 08   提取08 09
            let payloadDataStr = payloadData.toHexString()
            let payloadLen =  (payloadData.count + 1).hw_to4Bytes
            let allPayload = payloadLen().toHexString()+payloadType+payloadDataStr

            //版本号
            let version="01"
            
            let noneceBytes = (nonce+1).intToEightBytes() //UInt64(bigEndian: nonce+1)
            
            let gasPrice = (TradeUtility.GAS).intToEightBytes()
            
            let num =  NSDecimalNumber(string: "0")   //为了避免精度问题
            let s = num.multiplying(by: NSDecimalNumber(string:TradeUtility.RATE)).stringValue
            let amountLong = Int(s)!.intToEightBytes() //无符号字节
            
            //为签名留白
            let signull = TradeUtility.SIGNNULL //Utils.randomStr(len: 64)

            
            //version,type,nonece,fromPubkeyHash,gasPrice,Amount,signull,toPubkeyHash,allPayload
            let RawTransactionStr = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+signull+toPublicHash+allPayload
            
            print("RawTransactionStr=====\(RawTransactionStr)");
            //签名数据
            let sigall = Keycreat.Sign(msg: RawTransactionStr, pri: prikeyStr)!
            
            let tra = version+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
            
            let transha = Data(hexString:tra)!
            
            let txHash = Hash.keccak256(data:transha)
            
            let  transaction = version+txHash.toHexString()+type+noneceBytes.toHexString()+fromPubkeyStr+gasPrice.toHexString()+amountLong.toHexString()+sigall+toPublicHash+allPayload
            let apiModel = ApiResultEntity()
            
            apiModel.txHash = txHash.toHexString()
            apiModel.transaction = transaction
            
            return apiModel.toJSONString()!
            
        }catch {
            return "5000"
        }
    }
    
    
    
}

