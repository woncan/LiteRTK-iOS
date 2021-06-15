//
//  HCLocationModel.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/8.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit
import CoreLocation

class HCLocationModel: NSObject {

    /// 经度
    public var longitude: String = ""
    /// 纬度
    public var latitude: String = ""
    /// 高程
    public var altitude: String = ""
    /// 水平精确度
    public var horizontalAccuracy: String = ""
    /// 垂直精确度
    public var verticalAccuracy: String = ""
    
    
    public convenience init(location: CLLocation) {
        self.init()
        self.longitude = String(format: "%.9f", location.coordinate.longitude)
        self.latitude = String(format: "%.9f", location.coordinate.latitude)
        self.altitude = String(format: "%.9f", location.altitude)
        self.horizontalAccuracy = String(format: "%.6f", location.horizontalAccuracy)
        self.verticalAccuracy = String(format: "%.6f", location.verticalAccuracy)
    }
    
    public func toList() -> [[String]] {
        var list = [[String]]()
        list.append(["经度", longitude])
        list.append(["纬度", latitude])
        list.append(["高程", altitude])
        list.append(["水平精确度", horizontalAccuracy])
        list.append(["垂直精确度", verticalAccuracy])
        return list
    }
}
