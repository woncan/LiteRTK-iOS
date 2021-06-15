//
//  HCCacheUtil.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/9.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

enum CacheCategory: String {
    /// 差分数据缓存key
    case diffDataKey = "kDiffDataKey_20210611"
}

class HCCacheUtil: NSObject {
    
    static func saveCache(data: [String: Any], key: String) {
        let ret = NSKeyedArchiver.archiveRootObject(data, toFile: rootFilePathWithName(name: key))
        MyLog("缓存字典数据\(key):\(ret ? "成功": "失败")")
    }
    
    static func getCache(key: String) -> [String: Any] {
        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: rootFilePathWithName(name: key)) as? [String: Any]
        return dict ?? [String: Any]()
    }
    
    static func deleteAllCache() {
        let manager = FileManager.default
        guard let path = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return
        }
        if let contents = try? manager.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) {
            for url in contents {
                try? manager.removeItem(at: url)
            }
        }
    }
    
    static func rootFilePathWithName(name: String) -> String {
        return NSString(string: projRootPath()).appendingPathComponent(name)
    }
    
    static func projRootCachePath() -> String {
        return projRootPathWithKey(key: "sportsCache")
    }
    
    static func projRootPathWithKey(key: String) -> String {
        let keyFolderPath = NSString(string: projRootPath()).appendingPathComponent(key)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: keyFolderPath) {
            try? fileManager.createDirectory(atPath: keyFolderPath, withIntermediateDirectories: true, attributes: nil)
        }
        return keyFolderPath
    }
    
    static func projRootPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
}
