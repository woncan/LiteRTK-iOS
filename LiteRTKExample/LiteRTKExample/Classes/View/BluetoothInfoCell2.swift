//
//  BluetoothInfoCell2.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/10.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class BluetoothInfoCell2: UITableViewCell {

    var nameLabel: UILabel!
    var valueLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setUI()
    }
    
    func configItem(json: JSON) {
        nameLabel.text = json["key"].string
        valueLabel.text = json["value"].string
    }
    
    func setUI() {
        nameLabel = UILabel(text: "", textColor: "666666".color(), mediumFontSize: kFont14, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        valueLabel = UILabel(text: "", textColor: "333333".color(), mediumFontSize: kFont14, textAlignment: .right)
        contentView.addSubview(valueLabel)
        
        let arrow = UIImageView(image: UIImage(named: "rightArrow"))
        contentView.addSubview(arrow)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(valueLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left).offset(-10)
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
