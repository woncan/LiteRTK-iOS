//
//  SetDiffInfoVC.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/8.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//

import UIKit

class SetDiffInfoVC: BaseVC, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var cacheModel: HCDiffModel = HCDiffModel.getCacheData()
    var list: [JSON] = [JSON]()
    var requestMountPointsBlock: (() -> ())?
    var saveBlock: ((_ model: HCDiffModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "数据链设置"
        view.backgroundColor = "f9f9f9".color()
        setUI()
        setData()
    }
    
    func setData() {
        list = cacheModel.toList()
    }
    
    func setUI() {
        tableView = UITableView(frame: .zero, style: .plain, target: self)
        view.addSubview(tableView)
        tableView.register(SetDiffInfoCell.self, forCellReuseIdentifier: NSStringFromClass(SetDiffInfoCell.self))
        
        let saveButton = UIButton(type: .custom)
        view.addSubview(saveButton)
        
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setBackgroundImage("4e71f2".toImage(), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: kFont14)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.bottom.equalTo(-BOTTOM_BAR_FIX_H - 20)
        }
        saveButton.layer.cornerRadius = 5.0
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(toSave), for: .touchUpInside)
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: PHONE_SIZE_W, height: 70))
        tableView.tableFooterView = footer
        let mountButton = UIButton(type: .custom)
        footer.addSubview(mountButton)
        mountButton.setTitle("获取挂载点", for: .normal)
        mountButton.setTitleColor(.white, for: .normal)
        mountButton.setBackgroundImage("4e71f2".toImage(), for: .normal)
        mountButton.titleLabel?.font = UIFont.systemFont(ofSize: kFont14)
        mountButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30).priority(.high)
            make.height.equalTo(40)
            make.top.equalTo(10)
        }
        mountButton.layer.cornerRadius = 5.0
        mountButton.layer.masksToBounds = true
        mountButton.addTarget(self, action: #selector(getMountPoint), for: .touchUpInside)
    }
    
    @objc func toSave() {
        if cacheModel.ip.count == 0 {
            iToast.showMessageCenter("请填写IP地址")
            return
        }
        if cacheModel.port == -1 {
            iToast.showMessageCenter("请填写端口号")
            return
        }
        if cacheModel.account.count == 0 {
            iToast.showMessageCenter("请填写账号")
            return
        }
        if cacheModel.password.count == 0 {
            iToast.showMessageCenter("请填写密码")
            return
        }
        view.endEditing(true)
        cacheModel.toSaveCache()
        if let saveBlock = saveBlock {
            saveBlock(cacheModel)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func getMountPoint() {
        if let requestMountPointsBlock = requestMountPointsBlock {
            view.endEditing(true)
            iToast.showLoading()
            requestMountPointsBlock()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SetDiffInfoCell.self)) as! SetDiffInfoCell
        if indexPath.row < list.count {
            cell.configItem(json: list[indexPath.row])
        }
        cell.clickButtonBlock = {
            [weak self] in
            self?.changeMountPoint()
        }
        cell.tvDidChangedBlock = {
            [weak self] (text) in
            self?.changeValue(text: text, row: indexPath.row)
        }
        return cell
    }
    
    func changeValue(text: String, row: Int) {
        switch row {
        case 0:
            cacheModel.ip = text
        case 1:
            cacheModel.port = text.count == 0 ? -1 : (Int(text) ?? 8003)
        case 2:
            cacheModel.account = text
        case 3:
            cacheModel.password = text
        default:
            break
        }
    }
    
    func changeMountPoint() {
        if cacheModel.mountPointList.count == 0 {
            iToast.showMessageCenter("先获取挂载点")
            return
        }
        let alertController = UIAlertController(title: "选择挂载点", message: nil, preferredStyle: .alert)
        for item in cacheModel.mountPointList {
            alertController.addAction(UIAlertAction(title: item, style: .default, handler: { action in
                self.setCurrentMountPoint(title: action.title ?? "")
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func setCurrentMountPoint(title: String) {
        cacheModel.currentMountPoint = title
        setData()
        tableView.reloadData()
    }
    
    func setMountPoints(mountPoints: [String]) {
        cacheModel.mountPointList = mountPoints
        setData()
        iToast.showMessageCenter("获取挂载点成功")
    }
}
