//
//  UIColor+Extension.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

/*
 *自定义全局日志方法
 */
public func MyLog<T>(_ message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line) -> Void {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let timestamp = Date().timeIntervalSince1970
    print("时间:\(timestamp) 日志: \(fileName) 第\(lineNum)行 内容:\(message)")
    #endif
}
