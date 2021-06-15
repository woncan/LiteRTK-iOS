//
//  UITableView+Extension.swift
//
//
//  Created by iband on 2019/1/4.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public convenience init(frame: CGRect, style: UITableView.Style, target: Any) {
        self.init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.delegate = target as? UITableViewDelegate
        self.dataSource = target as? UITableViewDataSource
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.separatorStyle = .none
        self.tableFooterView = UIView()
    }
}
