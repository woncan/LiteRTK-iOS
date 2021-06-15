//
//  HCDeviceInfoModel.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//  通过差分计算后的设备信息

import UIKit

class HCDeviceInfoModel: NSObject {

    /// 设备名称
    public var name: String = ""
    /// 设备状态
    public var state: String = ""
    /// GPS数量
    public var gpsCount: Int = 0
    /// 水平精度
    public var horizontalAccuracy: String = ""
    /// 垂直精度
    public var verticalAccuracy: String = ""
    /// 定位精度
    public var gpsLevel: String = ""
    /// 经度方位
    public var longitudeDiretion: String = ""
    /// 经度
    public var longitude: String = ""
    /// 纬度方位
    public var latitudeDirection: String = ""
    /// 纬度
    public var latitude: String = ""
    /// 海拔
    public var height: String = ""
    /// 高程异常值
    public var altitudeExceptionValue: String = ""
    /// 电量
    public var electricity: String = ""
    /// 加速度
    public var acceleration: String = ""
    /// 角速度
    public var angularVelocity: String = ""
    /// NEMA原始数据，在获取差分数据时需要用到
    public var nemaSourceText: String = ""
    /// 差分延时
    public var diffDelayTime: String = ""
    /// 激光开关
    public var isLaser: String = "0"
    
    public convenience init(json: JSON, deviceName: String, isConnected: Bool = true) {
        self.init()
        self.name = deviceName
        changeState(isConnected: isConnected)
        
        let locArr = getArrFromText(text: json["LOC"].string ?? "")
        self.gpsCount = Int(getValue(arr: locArr, position: 0)) ?? 0
        
        let horizontalAccuracyValue = (Double(getValue(arr: locArr, position: 1)) ?? 0.0) / 1000.0
        let verticalAccuracyValue = (Double(getValue(arr: locArr, position: 2)) ?? 0.0) / 1000.0
        self.horizontalAccuracy = String(format: "%.3f", horizontalAccuracyValue)
        self.verticalAccuracy = String(format: "%.3f", verticalAccuracyValue)
        
        self.nemaSourceText = json["NEMA"].string ?? ""
        let nemaArr = getArrFromText(text: self.nemaSourceText)
        let level = Int(getValue(arr: nemaArr, position: 6)) ?? 0
        self.gpsLevel = ["不可用", "单点定位", "码差分", "无效PPS", "固定解（RTK FIX）", "浮点解", "正在估算"][level % 7]
        self.longitudeDiretion = getValue(arr: nemaArr, position: 5)
        self.longitude = getDegree(value: getValue(arr: nemaArr, position: 4))
        self.latitudeDirection = getValue(arr: nemaArr, position: 3)
        self.latitude = getDegree(value: getValue(arr: nemaArr, position: 2))
        self.height = getValue(arr: nemaArr, position: 9)
        self.altitudeExceptionValue = getValue(arr: nemaArr, position: 11)
        self.diffDelayTime = getValue(arr: nemaArr, position: 13)
        
        let staArr = getArrFromText(text: json["STA"].string ?? "")
        self.electricity = getValue(arr: staArr, position: 0)
      
        let gccArr = getArrFromText(text: json["GCC"].string ?? "")
        if gccArr.count >= 3 {
            self.acceleration = gccArr.prefix(3).joined(separator: ",")
        }
        if gccArr.count >= 6 {
            self.angularVelocity = gccArr.suffix(3).joined(separator: ",")
        }
    }
    
    public func changeState(isConnected: Bool) {
        self.state = isConnected ? "已连接" : "未连接"
    }
    
    public func toList() -> [[String]] {
        var list = [[String]]()
        list.append(["设备名称", name])
        list.append(["状态", state])
        list.append(["GPS收星颗数", "\(gpsCount)"])
        list.append(["水平精度(m)", horizontalAccuracy])
        list.append(["垂直精度(m)", verticalAccuracy])
        list.append(["定位精度", gpsLevel])
        list.append(["纬度\(latitudeDirection)(°)", latitude])
        list.append(["经度\(longitudeDiretion)(°)", longitude])
        list.append(["海拔(m)", height])
        list.append(["高程异常值(m)", altitudeExceptionValue])
        list.append(["差分延时时间(s)", diffDelayTime])
        list.append(["电量", electricity])
        list.append(["加速度", acceleration])
        list.append(["角速度", angularVelocity])
        list.append(["激光开关", isLaser])
        return list
    }
    
    private func getDegree(value: String) -> String {
        let v = (Double(value) ?? 0.0) / 100.0
        let ret1 = Double(Int(v))
        return String(format: "%.9f", (ret1 + (v - ret1) * 100.0 / 60.0))
    }
    
    private func getArrFromText(text: String) -> [String] {
        return text.components(separatedBy: ",")
    }
    
    private func getValue(arr: [String], position: Int) -> String {
        if position < arr.count {
            return arr[position]
        }
        return ""
    }
}
