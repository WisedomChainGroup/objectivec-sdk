//
//  BigEndian.swift
//  iosSdk
//
//  Created by peach on 2019/11/21.
//  Copyright © 2019 com.wisdom. All rights reserved.
//

import Foundation
extension Int {
    
    // MARK:- 转成 2位byte
    func hw_to2Bytes() -> [UInt8] {
        let UInt = UInt16.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 8),UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 4字节的bytes
    func hw_to4Bytes() -> [UInt8] {
        let UInt = UInt32.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
                UInt8(truncatingIfNeeded: UInt)]
    }
    // MARK:- 转成 8位 bytes
    func intToEightBytes() -> [UInt8] {
        let UInt = UInt64.init(Double.init(self))
        return [UInt8(truncatingIfNeeded: UInt >> 56),
                UInt8(truncatingIfNeeded: UInt >> 48),
                UInt8(truncatingIfNeeded: UInt >> 40),
                UInt8(truncatingIfNeeded: UInt >> 32),
                UInt8(truncatingIfNeeded: UInt >> 24),
                UInt8(truncatingIfNeeded: UInt >> 16),
                UInt8(truncatingIfNeeded: UInt >> 8),
                UInt8(truncatingIfNeeded: UInt)]
    }
}
