//
//  BaseNav.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/4.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BaseNav: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        self.interactivePopGestureRecognizer?.isEnabled = true
    }

}
