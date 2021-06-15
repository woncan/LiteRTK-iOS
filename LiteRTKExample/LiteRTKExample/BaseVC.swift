//
//  BaseVC.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/4.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var backClosure: (() -> ())?
    public var pageObj: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //如果不是栈底控制器才需要隐藏 根控制器不需要处理
        if self.navigationController?.children.count ?? 0 > 0 {
            if self.navigationController?.viewControllers.count == 1 {
                viewController.hidesBottomBarWhenPushed = true
            }
//            //判断控制器的类型
            if let vc = viewController as? BaseVC {
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: viewController, action: #selector(backVC))
            }
        }
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @objc func backVC() {
        if let block = backClosure {
            block()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }


}
