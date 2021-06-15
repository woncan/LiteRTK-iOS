//
//  BluetoothListCell.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BluetoothListCell: UITableViewCell {

    var nameLabel: UILabel!
    var stateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setUI()
    }
    
    func setName(name: String, isConnected: Bool) {
        nameLabel.text = name
        stateLabel.text = isConnected ? "已连接" : "未连接"
    }
    
    func setUI() {
        nameLabel = UILabel(text: "", textColor: "666666".color(), mediumFontSize: kFont14, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        stateLabel = UILabel(text: "", textColor: "666666".color(), mediumFontSize: kFont14, textAlignment: .right)
        contentView.addSubview(stateLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(stateLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        let line = UIView()
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kLineHeight)
        }
        line.backgroundColor = "dddddd".color()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
