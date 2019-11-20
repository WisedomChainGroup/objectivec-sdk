//
//  Utils.swift
// 
//
//  Created by peach on 2019/11/8.
//  Copyright © 2019 WisdomSDK. All rights reserved.
//

import Foundation


@objc class Utils:NSObject {
    
    // MARK: 随机数生成
    static func randomCustom(min: Int, max: Int) -> Int {
        var y = arc4random() % UInt32(max) + UInt32(min)
        print(Int(y))
        return Int(y)
    }
    
  
        /// 生成随机字符串
        ///
        /// - Parameters:
        ///   - count: 生成字符串长度
        ///   - isLetter: false=大小写字母和数字组成，true=大小写字母组成，默认为false
        /// - Returns: String
       static func random(_ count: Int, _ isLetter: Bool = false) -> String {
            
            var ch: [CChar] = Array(repeating: 0, count: count)
            for index in 0..<count {
                
                var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
                if num>57 && num<65 && isLetter==false { num = num%57+48 }
                else if num>90 && num<97 { num = num%90+65 }
                
                ch[index] = CChar(num)
            }
            
            return String(cString: ch)
        }
    
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyz"
    static  func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    /**
     判断是f否为数字
    **/
   static func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    /**
      JSONString转换为数组
    **/
   static func getArrayFromJSONString(jsonString:String) ->NSArray{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
        
    }
   
    // JSONString转换为字典
    
    static func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    
    
    // big-endian encoding
   /* static  func encodeUint64(value:String)->String {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 2))
        
        res[0] =(value & 0xFF00000000000000L) >> 56;
        res[1] = (value & 0x00FF000000000000L) >> 48;
        res[2] = (value & 0x0000FF0000000000L) >> 40;
        res[3] =  (value & 0x000000FF00000000L) >> 32;
        res[4] =  (value & 0x00000000FF000000L) >> 24;
        res[5] = (value & 0x0000000000FF0000L) >> 16;
        res[6] =  (value & 0x000000000000FF00L) >> 8;
        res[7] =  (value &  0x00000000000000FFL);
        return res;
    }*/
    
    

  
}
