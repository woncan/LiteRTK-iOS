//
//  UIViewController+iOS11VC.swift
//
//
//  Created by iband on 2019/1/8.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func fitIOS11WithScrollView(scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never;
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
}
