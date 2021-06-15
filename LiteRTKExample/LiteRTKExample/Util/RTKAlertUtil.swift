//
//  RTKAlertUtil.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/10.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

enum RtkType: Int {
    case Frequency = 0
    case Logger
    case HeightAngle
}

typealias RTKCallback = ((_ json: JSON, _ row: Int) -> ())

class RTKAlertUtil: NSObject {

    public class func show(json: JSON, rtkType: RtkType, row: Int, device: HCDevice, callback: RTKCallback?) {
        var json = json
        let callback = callback
        let alertController = UIAlertController(title: "", message:nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        if rtkType == .Logger {
            alertController.title = "开启日志"
            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
                self.toWriteData(rtkType: rtkType, device: device)
                json["isOn"].bool = true
                json["value"].string = "已开启"
                if let callback = callback {
                    callback(json, row)
                }
            }))
        } else {
            let isFrequency = rtkType == .Frequency
            alertController.title = isFrequency ? "设置频率" : "设置高度角"
            alertController.addTextField { tv in
                tv.placeholder = isFrequency ? "例：5000=5秒一次" : "高度角范围0~90度"
                tv.keyboardType = .numberPad
                tv.font = UIFont.systemFont(ofSize: kFont12)
            }
            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
                if let value = alertController.textFields?.first?.text {
                    if let v = UInt(value) {
                        self.toWriteData(rtkType: rtkType, device: device, value: v)
                        json["value"].string = "\(v)"
                        if let callback = callback {
                            callback(json, row)
                        }
                    }
                }
            }))
        }
        kLastVC?.present(alertController, animated: true, completion: nil)
    }
    
    public class func toWriteData(rtkType: RtkType, device: HCDevice, value: UInt = 0) {
        switch rtkType {
        case .Logger:
            RTKController.setLoggerOnTo(device)
        case .Frequency:
            RTKController.setFrequency(value, to: device)
        default:
            break
        }
    }
}
