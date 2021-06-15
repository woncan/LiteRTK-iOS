//
//  HCDiffDataModel.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/8.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

@objc class HCDiffDataModel: NSObject {
    /// ip地址
    @objc public var ip: String = "rtk.ntrip.qxwz.com"
    /// 端口号
    @objc public var port: Int = 8003
    /// 账号
    @objc public var account: String = ""
    /// 密码
    @objc public var password: String = ""
    /// 挂载点列表
    @objc public var mountPointList: [String] = []
    /// 当前挂载点
    @objc public var currentMountPoint: String = "AUTO"
    
    public convenience init(ip: String, port: Int, account: String, password: String, currentMountPoint: String) {
        self.init()
        self.ip = ip
        self.port = port
        self.account = account
        self.password = password
        self.currentMountPoint = currentMountPoint
    }
    
    public func toList() -> [JSON] {
        var list = [JSON]()
        list.append(JSON(["name": "IP地址", "value": ip, "placeholder": "请输入IP地址"]))
        list.append(JSON(["name": "端口号", "value": "\(port)", "placeholder": "请输入端口号"]))
        list.append(JSON(["name": "账号", "value": account, "placeholder": "请输入账号"]))
        list.append(JSON(["name": "密码", "value": password, "placeholder": "请输入密码", "isPassword": true]))
        list.append(JSON(["name": "挂载点", "value": currentMountPoint, "isMountPoint": true]))
        return list
    }
    
    public class func getCacheData() -> HCDiffDataModel {
        let cacheDict = HCCacheUtil.getCache(key: CacheCategory.diffDataKey.rawValue)
        return HCDiffDataModel.mj_object(withKeyValues: cacheDict)
    }
    
    public func toSaveCache() {
        if let data = self.mj_keyValues() as? [String : Any] {
            HCCacheUtil.saveCache(data: data, key: CacheCategory.diffDataKey.rawValue)
        }
    }
}
