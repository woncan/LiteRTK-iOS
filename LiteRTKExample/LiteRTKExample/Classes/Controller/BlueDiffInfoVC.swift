//
//  BlueDiffInfoVC.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//  蓝牙差分计算后的数据详情页

import UIKit

enum SocketTag: Int {
    case Connection = 100080  // 差分站连接
    case ICY  // Socket登录
    case AuthData // 获取差分数据
}

class BlueDiffInfoVC: BaseVC, HCSocketUtilDelegate, UITableViewDataSource, UITableViewDelegate {

    var device: HCDevice?
    var socketUtil: HCSocketUtil?
    var timer: Timer?
    var tableView: UITableView!
    var list: [[String]] = [[String]]()
    var model: HCDeviceInfoModel?
    var mountPointList: [String] = [String]()
    var diffDataModel: HCDiffModel!
    var justGetMountPoint: Bool = false
    var rtkParams: [JSON] = [
        JSON(["key": "设置频率", "value": "未设置"]),
        JSON(["key": "开启日志", "value": "未开启", "isOn": false]),
        JSON(["key": "设置高度角", "value": "未设置"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设备信息"
        setUI()
        setNavItem()
        setDiffData()
        // Socket连接
        toLoginSocket()
    }
    
    func setDiffData() {
        diffDataModel = HCDiffModel.getCacheData()
    }
    
    public func setData(model: HCDeviceInfoModel?) {
        model?.isLaser = self.model?.isLaser ?? "0"
        self.model = model
        reload()
    }
    
    private func reload() {
        self.list = model?.toList() ?? [[String]]()
        tableView.reloadData()
    }
    
    public func offline() {
        self.model?.changeState(isConnected: false)
        reload()
        socketUtil?.disconnect()
    }
    
    public func online() {
        toLoginSocket()
    }
    
    func setUI() {
        tableView = UITableView(frame: .zero, style: .grouped, target: self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        tableView.register(BluetoothInfoCell.self, forCellReuseIdentifier: NSStringFromClass(BluetoothInfoCell.self))
        tableView.register(BluetoothInfoCell2.self, forCellReuseIdentifier: NSStringFromClass(BluetoothInfoCell2.self))
        tableView.register(BlueDiffInfoHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(BlueDiffInfoHeader.self))
    }
    
    public convenience init(device: HCDevice) {
        self.init()
        self.device = device
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return list.count
        }
        return rtkParams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BluetoothInfoCell2.self)) as! BluetoothInfoCell2
            cell.configItem(json: rtkParams[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BluetoothInfoCell.self)) as! BluetoothInfoCell
        if indexPath.row < list.count {
            let items = list[indexPath.row]
            cell.configItem(leftKey: items[0], rightValue: items[1])
        }
        cell.clickSwitchBlock = {
            [weak self] (isOn) in
            self?.model?.isLaser = isOn ? "1" : "0"
            self?.tableView.reloadData()
            
            if let device = self?.device {
                RTKController.setLaserState(isOn, to: device)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }
        settingRTKParams(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(BlueDiffInfoHeader.self)) as! BlueDiffInfoHeader
        header.setTitle(title: ["蓝牙连接参数", "设置RTK参数"][section])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0.01
    }
    
    override func backVC() {
        super.backVC()
        removeTimer()
        socketUtil?.destroy()
        socketUtil = nil
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(socketUtil?.isConnected() ?? false) {
            removeTimer()
            toLoginSocket()
        } else {
            if let timer = timer {
                timer.fireDate = Date.distantPast
            }
        }
    }
}

extension BlueDiffInfoVC {
    func toLoginSocket() {
        if socketUtil?.isConnected() ?? false {
            return
        }
        if socketUtil == nil {
            socketUtil = HCSocketUtil.shared()
            socketUtil?.delegate = self
            socketUtil?.replaceDiffModel(diffDataModel)
        }
        socketUtil?.toLogin()
    }
    
    // HCSocketUtilDelegate methods
    func loginSuccess(_ tcpUtil: HCSocketUtil) {
        if timer == nil {
            timer = Timer(timeInterval: 1, target: self, selector: #selector(getDiffData), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
        timer?.fireDate = .distantPast
    }
    
    func loginFailure(_ tcpUtil: HCSocketUtil, error: Error?) {
        MyLog("socket连接失败: \(error?.localizedDescription ?? "")")
        removeTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.toLoginSocket()
        }
    }
    
    func didGetMountPointsSuccess(_ socketUtil: HCSocketUtil) {
        mountPointList = socketUtil.diffModel.mountPointList
        MyLog("获取到的挂载点有：\(mountPointList)")
        let setDiffInfoVC = kLastVC as? SetDiffInfoVC
        setDiffInfoVC?.setMountPoints(mountPoints: mountPointList)
    }
    
    func didWriteDataSuccess(_ socketUtil: HCSocketUtil, tag: Int) {
//        MyLog("写数据成功, tag = \(tag)")
    }
    
    /// 获取差分数据
    @objc func getDiffData() {
        socketUtil?.sendData("\(model?.nemaSourceText ?? "")\r\n\r\n")
    }
    
    /// 处理差分数据
    func didReadDiffDataSuccess(_ datas: [Data], socketUtil: HCSocketUtil) {
//        MyLog("分包后的数据： \(datas)")
        if let device = device {
            RTKController.send(datas, to: device)
        }
    }
}

extension BlueDiffInfoVC {
    
    func setNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "差分数据来源", style: .plain, target: self, action: #selector(changeDiffData))
    }
    
    /// 修改差分数据来源
    @objc func changeDiffData() {
        let setDiffInfoVC = SetDiffInfoVC()
        setDiffInfoVC.requestMountPointsBlock = {
            [weak self] in
            self?.requestMountPoints()
        }
        setDiffInfoVC.saveBlock = {
            [weak self] (model) in
            self?.afterChangeDiffData(model: model)
        }
        pushViewController(setDiffInfoVC, animated: true)
    }
    
    func afterChangeDiffData(model: HCDiffModel) {
        diffDataModel = model
        socketUtil?.replaceDiffModel(model)
        socketUtil?.disconnect()
    }
    
    /// Ntrip差分站连接，获取挂载点
    func requestMountPoints() {
        removeTimer()
        socketUtil?.getMountPoints()
    }
}

extension BlueDiffInfoVC {
    func settingRTKParams(row: Int) {
        let json = rtkParams[row]
        let type: RtkType = [RtkType.Frequency, RtkType.Logger, RtkType.HeightAngle][row]
        guard let device = device else {
            MyLog("未找到蓝牙设备")
            return
        }
        RTKAlertUtil.show(json: json, rtkType: type, row: row, device: device) {
            [weak self] (json, row) in
            self?.rtkParams[row] = json
            self?.tableView.reloadData()
        }
    }
}
