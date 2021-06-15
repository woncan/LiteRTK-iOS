//
//  BlueDiffInfoHeader.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/8.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BlueDiffInfoHeader: UITableViewHeaderFooterView {
    
    var titleLabel: UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setUI() {
        titleLabel = UILabel(text: "", textColor: "333333".color(), boldFontSize: kFont14, textAlignment: .left)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
