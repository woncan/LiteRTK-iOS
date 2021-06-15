//
//  Constant.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/4.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

let kBounds = UIScreen.main.bounds
let kSize = kBounds.size

public let KeyWindow = UIApplication.shared.keyWindow

/// 屏幕宽度
public let PHONE_SIZE_H: CGFloat = kSize.height
/// 屏幕高度
public let PHONE_SIZE_W: CGFloat = kSize.width

// 判断屏幕横竖屏状态
public func IsPortrait() -> Bool {
    if UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portraitUpsideDown {
        return true
    }
    return false
}

public let isPad = UIDevice.current.userInterfaceIdiom == .pad

/// 是否是iPhone X
public let IS_IPHONE_X = (!isPad && PHONE_SIZE_H >= 812.0)
/// 是否是小屏手机
public let IS_SMALL_PHONE = PHONE_SIZE_H < 667.0
/// 头部高度（包括状态栏）
public let TOP_BAR_H: CGFloat  = (IS_IPHONE_X ? 88 : 64)
/// tabbar高度
public let BOTTOM_BAR_H: CGFloat = isPad ? 50 : (IS_IPHONE_X ? 83 : 49)
/// 底部高度
public let BOTTOM_BAR_FIX_H: CGFloat = (IS_IPHONE_X ? 34 : 0)
/// 状态栏高度
public let TOP_BAR_FIX_H: CGFloat = (IS_IPHONE_X ? 24 : 0)
/// 顶部安全区域远离高度
public let TOP_BAR_SAFE_H: CGFloat = (IS_IPHONE_X ? 44 : 0)

public let kLineHeight = 1.0 / UIScreen.main.scale


let kSmallPhoneScale: CGFloat = IS_SMALL_PHONE ? 0.85 : 1

let kIPadScale: CGFloat = isPad ? 1.5 : 1

public var kLastVC: UIViewController? {
    let nav = UIApplication.shared.keyWindow?.rootViewController as? BaseNav
    return nav?.viewControllers.last
}

// iPad加大5号字体
let kIpadFontAdd: CGFloat = 5

let kFont25: CGFloat = (IS_SMALL_PHONE ? 23 : (isPad ? 25 + kIpadFontAdd : 25))
let kFont24: CGFloat = (IS_SMALL_PHONE ? 22 : (isPad ? 24 + kIpadFontAdd : 24))
let kFont22: CGFloat = (IS_SMALL_PHONE ? 20 : (isPad ? 22 + kIpadFontAdd : 22))
let kFont20: CGFloat = (IS_SMALL_PHONE ? 18 : (isPad ? 20 + kIpadFontAdd : 20))
let kFont18: CGFloat = (IS_SMALL_PHONE ? 16 : (isPad ? 18 + kIpadFontAdd : 18))
let kFont16: CGFloat = (IS_SMALL_PHONE ? 14 : (isPad ? 16 + kIpadFontAdd : 16))
let kFont15: CGFloat = (IS_SMALL_PHONE ? 13 : (isPad ? 15 + kIpadFontAdd : 15))
let kFont14: CGFloat = (IS_SMALL_PHONE ? 12 : (isPad ? 14 + kIpadFontAdd : 14))
let kFont13: CGFloat = (IS_SMALL_PHONE ? 11 : (isPad ? 13 + kIpadFontAdd : 13))
let kFont12: CGFloat = (IS_SMALL_PHONE ? 10 : (isPad ? 12 + kIpadFontAdd : 12))
let kFont11: CGFloat = (IS_SMALL_PHONE ? 9 : (isPad ? 11 + kIpadFontAdd : 11))
let kFont10: CGFloat = (IS_SMALL_PHONE ? 8 : (isPad ? 10 + kIpadFontAdd : 10))

public func getRectWithHeight(height: CGFloat) -> CGRect {
    return CGRect(x: 0, y: 0, width: PHONE_SIZE_W, height: height)
}

public func getRectWithSize(width: CGFloat, height: CGFloat) -> CGRect {
    return CGRect(x: 0, y: 0, width: width, height: height)
}

public var kSafeSpace: CGFloat {
    if IS_IPHONE_X {
        if UIScreen.main.scale == 2 {
            return 11
        }
        return 14
    }
    return 0
}

let ApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
