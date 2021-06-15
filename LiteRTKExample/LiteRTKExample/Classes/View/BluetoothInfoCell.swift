//
//  BluetoothInfoCell.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BluetoothInfoCell: UITableViewCell {

    var nameLabel: UILabel!
    var valueLabel: UILabel!
    var aSwitch: UISwitch!
    var clickSwitchBlock: ((_ isOn: Bool) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setUI()
    }
    
    func configItem(leftKey: String, rightValue: String) {
        nameLabel.text = leftKey
        valueLabel.text = rightValue
        valueLabel.isHidden = ["激光开关"].contains(leftKey)
        aSwitch.isHidden = !valueLabel.isHidden
        if !aSwitch.isHidden {
            aSwitch.isOn = rightValue == "1"
        }
    }
    
    func setUI() {
        nameLabel = UILabel(text: "", textColor: "666666".color(), mediumFontSize: kFont14, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        valueLabel = UILabel(text: "", textColor: "333333".color(), mediumFontSize: kFont14, textAlignment: .right)
        contentView.addSubview(valueLabel)
        
        aSwitch = UISwitch()
        contentView.addSubview(aSwitch)
        aSwitch.addTarget(self, action: #selector(clickSwitch), for: .touchUpInside)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(valueLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        aSwitch.snp.makeConstraints { make in
            make.right.equalTo(valueLabel)
            make.centerY.equalTo(nameLabel)
        }
        aSwitch.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        let line = UIView()
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kLineHeight)
        }
        line.backgroundColor = "dddddd".color()
    }
    
    @objc func clickSwitch() {
        if let clickSwitchBlock = clickSwitchBlock {
            clickSwitchBlock(aSwitch.isOn)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
