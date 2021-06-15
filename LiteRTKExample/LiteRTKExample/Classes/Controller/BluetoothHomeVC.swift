//
//  BluetoothHomeVC.swift
//  LiteRTKExample
//
//  Created by iband on 2021/6/7.
//  Copyright © 2021 武汉桓参工程科技有限公司. All rights reserved.
//  连接蓝牙

import UIKit

class BluetoothHomeVC: BaseVC, UITableViewDataSource, UITableViewDelegate, HCFilterRulesProtocol, HCToolDelegate {

    var tableView: UITableView!
    var list: [HCDevice] = [HCDevice]()
    var connetedUUIDMap: [String: Bool] = [String: Bool]()
    var searchButton: UIButton!
    var currentConenctedDevice: HCDevice?
    var reveiveBluetoothText: NSMutableString = NSMutableString()
    lazy var bluetoothUtil: HCBluetoothUtil = {
        let b = HCBluetoothUtil.shared()
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "连接蓝牙"
        setUI()
        bluetoothUtil.filterDelegate = self
        bluetoothUtil.delegate = self
    }
    
    func setUI() {
        tableView = UITableView(frame: .zero, style: .plain, target: self)
        view.addSubview(tableView)
        tableView.register(BluetoothListCell.self, forCellReuseIdentifier: NSStringFromClass(BluetoothListCell.self))
        
        searchButton = UIButton(type: .custom)
        view.addSubview(searchButton)
        
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(searchButton.snp.top).offset(-15)
        }
        
        searchButton.setTitle("搜索设备", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.setBackgroundImage("4e71f2".toImage(), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: kFont14)
        searchButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.bottom.equalTo(-BOTTOM_BAR_FIX_H - 20)
        }
        searchButton.layer.cornerRadius = 5.0
        searchButton.layer.masksToBounds = true
        searchButton.addTarget(self, action: #selector(serachBluetoothDevice), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BluetoothListCell.self)) as! BluetoothListCell
        if indexPath.row < list.count {
            let device = list[indexPath.row]
            cell.setName(name: device.name, isConnected: connetedUUIDMap[device.identifierUUIDString] ?? false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = list[indexPath.row]
        if connetedUUIDMap[device.identifierUUIDString] ?? false {
            toNextPage(device: device)
            return
        }
        bluetoothUtil.connect(list[indexPath.row])
        iToast.showLoading()
    }
    
    func toNextPage(device: HCDevice) {
        pushViewController(BlueDiffInfoVC(device: device), animated: true)
    }
}

extension BluetoothHomeVC {
    @objc func serachBluetoothDevice() {
        bluetoothUtil.beginScan()
    }
    
    func centerManagerSetScanAfterRules() -> [String : Any] {
        return [HCScanAfterFilterPeripheralName: "WHand"]
    }
    
    func btState(_ isOn: Bool, describe des: String) {
        if !isOn {
            // 未连接
            iToast.showMessageCenter("请先打开蓝牙连接")
            let diffInfoVC = kLastVC as? BlueDiffInfoVC
            diffInfoVC?.offline()
            connetedUUIDMap.removeValue(forKey: currentConenctedDevice?.identifierUUIDString ?? "")
            tableView.reloadData()
        } else {
            if let device = currentConenctedDevice {
                // 自动重连
                bluetoothUtil.connect(device)
                let diffInfoVC = kLastVC as? BlueDiffInfoVC
                diffInfoVC?.online()
            }
        }
    }
    
    func btToolScanResbons(withDevice devices: [HCDevice]?) {
        if let tempList = devices {
            list = tempList
            tableView.reloadData()
        }
    }
    
    func btToolIsConnected(_ isConnected: Bool, with device: HCDevice) {
        connetedUUIDMap[device.identifierUUIDString] = isConnected
        tableView.reloadData()
        currentConenctedDevice = device
        iToast.hideLoading()
    }
    
    func btToolDisconnected(_ device: HCDevice, error: Error?) {
        btState(false, describe: "连接断开")
        HCBluetoothUtil.shared().cancelConnection(device)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            HCBluetoothUtil.shared().connect(device)
        }
    }
    
    func btToolDidUpdate(from device: HCDevice, characteristicUUIDsString uuidStr: String, value data: Data, error: Error?) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        reveiveBluetoothText.append(text)
        if text.hasSuffix("\r\n") {
            let list = reveiveBluetoothText.components(separatedBy: "\r\n")
            autoreleasepool {
                for item in list {
                    if item.count <= 0 {
                        continue
                    }
//                    MyLog("接收蓝牙数据 \(item)")
                    if let itemData = item.data(using: .utf8) {
                        if let info = try? JSON(data: itemData) {
                            if info["NEMA"].string == nil {
                                // 日志或者其他的数据, TODO
                                continue
                            }
//                            MyLog("接收蓝牙数据 \(info)")
                            let diffInfoVC = kLastVC as? BlueDiffInfoVC
                            diffInfoVC?.setData(model: HCDeviceInfoModel(json: info, deviceName: device.name, isConnected: connetedUUIDMap[device.identifierUUIDString] ?? false))
                        }
                    }
                }
            }
            reveiveBluetoothText.deleteCharacters(in: NSMakeRange(0, reveiveBluetoothText.length))
        }
    }
}
