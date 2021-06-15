//
//  iToast.swift
//  Sport
//
//  Created by iband on 2020/6/4.
//  Copyright © 2020 iband. All rights reserved.
//

import Foundation
import Toast_Swift

private let dissmissTime: Double = 2

class iToast: NSObject {
    /// 中间显示toast
    ///
    /// - Parameter message: 显示的提示
    open class func showMessageCenter(_ message: String) {
        self.hideLoading()
        KeyWindow?.makeToast(message, duration: dissmissTime, position: .center)
    }
    
    open class func showSyncMessageCenter(_ message: String) {
        DispatchQueue.main.async {
            iToast.showMessageCenter(message)
        }
    }
    
    /// 底部显示toast
    ///
    /// - Parameter message: 显示的提示
    open class func showMessageBottom(_ message: String) {
        self.hideLoading()
        KeyWindow?.makeToast(message, duration: dissmissTime, position: .bottom)
    }
    
    /// 等待动画
    /// - Parameter isLandscape: 是否横屏页面
    open class func showLoading(isLandscape: Bool = false) {
        ToastManager.shared.isQueueEnabled = true
        let toastView = UIImageView(image: UIImage(named: "img_loading"))
        toastView.frame.size = CGSize(width: 50, height: 50)
        rotate360Degree(toastView)
        let point = isLandscape ? CGPoint(x: PHONE_SIZE_W / 2, y: PHONE_SIZE_H / 2) : CGPoint(x: PHONE_SIZE_W / 2, y: PHONE_SIZE_H / 2)
        KeyWindow?.showToast(toastView, duration: 100, point: point)
        KeyWindow?.isUserInteractionEnabled = false
    }
    
    public class func rotate360Degree(_ rotateView: UIView) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 旋转角度
        rotationAnimation.duration = 0.6 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = HUGE // 旋转次数
        rotateView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 动画消失
    open class func hideLoading() {
        KeyWindow?.hideAllToasts()
        KeyWindow?.isUserInteractionEnabled = true
    }
    
    open class func syncHideLoading() {
        DispatchQueue.main.async {
            iToast.hideLoading()
        }
    }
}
