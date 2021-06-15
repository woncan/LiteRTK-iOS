//
//  HCDiffModel+Extension.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/11.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

extension HCDiffModel {
    
    public func toList() -> [JSON] {
        var list = [JSON]()
        list.append(JSON(["name": "IP地址", "value": ip, "placeholder": "请输入IP地址"]))
        list.append(JSON(["name": "端口号", "value": "\(port)", "placeholder": "请输入端口号"]))
        list.append(JSON(["name": "账号", "value": account, "placeholder": "请输入账号"]))
        list.append(JSON(["name": "密码", "value": password, "placeholder": "请输入密码", "isPassword": true]))
        list.append(JSON(["name": "挂载点", "value": currentMountPoint, "isMountPoint": true]))
        return list
    }
    
    public class func getCacheData() -> HCDiffModel {
        let cacheDict = HCCacheUtil.getCache(key: CacheCategory.diffDataKey.rawValue)
        return HCDiffModel.mj_object(withKeyValues: cacheDict)
    }
    
    public func toSaveCache() {
        if let data = self.mj_keyValues() as? [String : Any] {
            HCCacheUtil.saveCache(data: data, key: CacheCategory.diffDataKey.rawValue)
        }
    }
}
