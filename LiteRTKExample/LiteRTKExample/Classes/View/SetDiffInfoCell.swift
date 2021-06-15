//
//  SetDiffInfoCell.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/9.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class SetDiffInfoCell: UITableViewCell {

    var nameLabel: UILabel!
    var textField: UITextField!
    var button: UIButton!
    var clickButtonBlock: (() -> ())?
    var tvDidChangedBlock: ((_ text: String) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setUI()
    }
    
    func configItem(json: JSON) {
        nameLabel.text = json["name"].string
        textField.isHidden = json["isMountPoint"].bool ?? false
        button.isHidden = !textField.isHidden
        if button.isHidden {
            textField.text = json["value"].string
            textField.placeholder = json["placeholder"].string
            textField.isSecureTextEntry = json["isPassword"].bool ?? false
            if json["isPort"].bool ?? false {
                textField.keyboardType = .numberPad
            } else {
                textField.keyboardType = .default
            }
        } else {
            button.setTitle(json["value"].string ?? "AUTO", for: .normal)
        }
    }
    
    func setUI() {
        nameLabel = UILabel(text: "", textColor: "333333".color(), mediumFontSize: kFont14, textAlignment: .left)
        contentView.addSubview(nameLabel)
        
        textField = UITextField()
        contentView.addSubview(textField)
        textField.textAlignment = .right
        textField.font = UIFont.systemFont(ofSize: kFont14)
        textField?.textColor = nameLabel.textColor
        textField.addTarget(self, action: #selector(tvDidChanged), for: .editingChanged)
        
        button = UIButton(type: .custom)
        contentView.addSubview(button)
        button.setTitle("AUTO", for: .normal)
        button.setTitleColor(nameLabel.textColor, for: .normal)
        button.titleLabel?.font = nameLabel.font
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(20)
            make.right.equalTo(-15)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(30)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.right.width.height.equalTo(textField)
        }
    }
    
    @objc func tvDidChanged() {
        if let tvDidChangedBlock = tvDidChangedBlock {
            tvDidChangedBlock(textField.text ?? "")
        }
    }
    
    @objc func clickButton() {
        endEditing(true)
        if let clickButtonBlock = clickButtonBlock {
            clickButtonBlock()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
