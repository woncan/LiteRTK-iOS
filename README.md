## LiteRTK-iOS接入指南（暂时仅支持真机调试）

####  一、下载demo源码。[链接地址](https://github.com/woncan/LiteRTK-iOS/archive/refs/heads/master.zip)

#### 二、解压后，将framework中的LiteRTK.framework静态库添加至自己的项目中。

![](http://survey-file.woncan.cn/firmware/20210615-153711/6c5bbe6a-3b69-40fd-8769-04b7d9478518.png)

#### 三、开始使用

##### 1.引入引入sdk，在项目pch(OC)或者桥接文件(Swift)中引入LiteRTK SDK

```swift
#import <LiteRTK/LiteRTK.h>
```

##### 2.设置日志开关

```swift
/// 设置RTK SDK日志开关
func setLogger() {
  RTKLog.setLogEnable(true)
}
```

##### 3.蓝牙搜索及连接(BluetoothHomeVC)

##### 蓝牙搜索

##### 新建蓝牙工具类并设置代理：

```swift
lazy var bluetoothUtil: HCBluetoothUtil = {
 	let b = HCBluetoothUtil.shared()
  return b
}()

bluetoothUtil.filterDelegate = self
bluetoothUtil.delegate = self
```

##### 蓝牙搜索

```swift
@objc func serachBluetoothDevice() {
  bluetoothUtil.beginScan()
}
```

##### 设置需要搜索的蓝牙外设设备的匹配名称

```swift
func centerManagerSetScanAfterRules() -> [String : Any] {
  return [HCScanAfterFilterPeripheralName: "WHand"]
}
```

##### 搜索结果，刷新UI列表

```swift
func btToolScanResbons(withDevice devices: [HCDevice]?) {
  if let tempList = devices {
    list = tempList
    tableView.reloadData()
  }
}
```

##### 点击cell，连接对应的设备

```swift
bluetoothUtil.connect(list[indexPath.row])
```

##### 蓝牙连接成功回调，根据状态刷新UI

```swift
func btToolIsConnected(_ isConnected: Bool, with device: HCDevice) {
  connetedUUIDMap[device.identifierUUIDString] = isConnected
  tableView.reloadData()
  currentConenctedDevice = device
  iToast.hideLoading()
}
```

##### 蓝牙断开连接回调，根据状态刷新UI，可以设置自动重连

```swift
func btToolDisconnected(_ device: HCDevice, error: Error?) {
  btState(false, describe: "连接断开")
  HCBluetoothUtil.shared().cancelConnection(device)
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    HCBluetoothUtil.shared().connect(device)
  }
}
```

##### 处理从蓝牙设备接收到的数据。使用\r\n分割数据

```swift
func btToolDidUpdate(from device: HCDevice, characteristicUUIDsString uuidStr: String, value data: Data, error: Error?) {}
```

##### 4.Socket连接，收发数据(BlueDiffInfoVC)

##### 连接Socket

```swift
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
```

##### 登录成功，使用Timer循环获取差分数据

```swift
func loginSuccess(_ tcpUtil: HCSocketUtil) {
  if timer == nil {
    timer = Timer(timeInterval: 1, target: self, selector: #selector(getDiffData), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: .common)
  }
  timer?.fireDate = .distantPast
}

/// 获取差分数据
@objc func getDiffData() {
  socketUtil?.sendData("\(model?.nemaSourceText ?? "")\r\n\r\n")
}
```

##### 登录失败，自动重连

```swift
func loginFailure(_ tcpUtil: HCSocketUtil, error: Error?) {
  MyLog("socket连接失败: \(error?.localizedDescription ?? "")")
  removeTimer()
  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.toLoginSocket()
  }
}
```

##### 获取到差分数据后，写入蓝牙设备

```swift
/// 处理差分数据
func didReadDiffDataSuccess(_ datas: [Data], socketUtil: HCSocketUtil) {
  if let device = device {
    RTKController.send(datas, to: device)
  }
}
```

##### 获取挂载点。需要先断开连接

```swift
/// Ntrip差分站连接，获取挂载点
func requestMountPoints() {
  removeTimer()
  socketUtil?.getMountPoints()
}

func didGetMountPointsSuccess(_ socketUtil: HCSocketUtil) {
  mountPointList = socketUtil.diffModel.mountPointList
  MyLog("获取到的挂载点有：\(mountPointList)")
}
```

##### 5.差分数账号设置(SetDiffInfoVC)

##### 选择挂载点时，需要使用Socket去获取挂载点。







