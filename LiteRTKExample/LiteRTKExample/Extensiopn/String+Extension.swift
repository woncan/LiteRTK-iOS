//
//  String+Extension.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/4.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

extension String {
    public func color() -> UIColor {
        let scanner = Scanner(string: self)

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /// 16进制字符串转成Data
    public func hexStringToData() -> Data? {
        return self.data(using: .utf8)
    }
    
    public func toImage() -> UIImage {
        return self.color().toImage()
    }
}
