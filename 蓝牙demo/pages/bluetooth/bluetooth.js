// pages/bluetooth/bluetooth.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    isblue: false,
    textColor: '#666666',
    showblueState: '获取手机蓝牙状态',
    showText: '搜寻附近的蓝牙设备',
    deviceId: '',
    joinDevaces: '',
    joinSuccess: '',
    buleToothServices: '',
    ToothServices: [],       //设备的所有服务
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

    
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
  
  },
  openBluetooth: function() {
    wx.openBluetoothAdapter({
      success: (res) => {
        console.log(res)
        this.setData({
          isblue: true,
          textColor: '#416eed'
        })
        wx.onBluetoothDeviceFound( (device) => {    //监听寻找到新设备的事件
          if (this.data.deviceId != ''){
            return
          }
          console.log('new device list has founded')
          console.log(device)
          console.log(device.devices.length)
          if (device.devices.length != 0) {
            var text = '已发现设备：'
            for (var i = 0; i < device.devices.length; i ++){
              let dev = device.devices[i]
              text = text + 'name:' + dev.name
            }

            this.setData({
              showText: text,
              deviceId: device.devices[0].deviceId,
              joinDevaces: '连接：deviceId:' + device.devices[0].deviceId
            })
            wx.stopBluetoothDevicesDiscovery({
              success: (res1) => {
              }
            })
          }
        })

        wx.onBLEConnectionStateChange((State) => {      //监听低功耗蓝牙连接的错误事件，包括设备丢失，连接异常断开等等。
          console.log(State)
        })
      },
      fail: (res) => {
        this.setData({
          isblue: false,
          textColor: '#666666'
        })
        wx.showToast({
          title: '您的蓝牙未打开',
          icon: 'loading',
          duration: 3000
        })

      }
    })
  },
  getBluetoothState: function() {
    if (this.data.isblue) {
      console.log('获取蓝牙的状态')
      wx.getBluetoothAdapterState({
        success: (res) => {
          console.log(res)
          if (res.available == false){
            wx.showToast({
              title: '您的蓝牙未被发现',
              icon: 'loading',
              duration: 3000
            })
            this.setData({
              showblueState: '蓝牙适配器不可用'
            })
          }else{
            this.setData({
              showblueState: '蓝牙适配器可用'
            })
          }
        }
      })
    }
    
  },
  startBluetoothDevices: function() {
    // 以微信硬件平台的蓝牙智能灯为例，主服务的 UUID 是 FEE7。传入这个参数，只搜索主服务 UUID 为 FEE7 的设备
    if (this.data.isblue) {
      console.log('开始搜寻设备')
      wx.startBluetoothDevicesDiscovery({
        success: (res) => {
          console.log(res)
        }
      })
    }
  },
  createBLE: function() {
    if (this.data.isblue && this.data.deviceId != 0) {
      console.log('连接设备')
      wx.createBLEConnection({
        // 这里的 deviceId 需要已经通过 createBLEConnection 与对应设备建立链接 
        deviceId: this.data.deviceId,
        success: (res) => {
          console.log(res)
          this.setData({
            joinSuccess: '连接成功，点击断开连接！',
            buleToothServices: '点击获取设备所有服务'
          })
          wx.onBLEConnectionStateChange((change) => {
            // 该方法回调中可以用于处理连接意外断开等异常情况
            console.log(`device ${change.deviceId} state has changed, connected: ${change.connected}`)
          })

        }
      })
    }
  },

  closeBLE: function () {
    if (this.data.isblue && this.data.joinSuccess != 0 && this.data.deviceId != 0) {
      console.log('点击断开你连接')
      wx.closeBLEConnection({
        deviceId: this.data.deviceId,
        success: (res) => {
          console.log(res)
          this.setData({
            joinSuccess:'',
            joinDevaces:'',
            buleToothServices: '',
            showText: '搜寻附近的蓝牙设备',
            deviceId: '',
            ToothServices: []
          })
        }
      })
    }
  },

  getServices: function () {
    if (this.data.isblue && this.data.buleToothServices != 0 && this.data.deviceId != 0) {
      wx.getBLEDeviceServices({
        // 这里的 deviceId 需要已经通过 createBLEConnection 与对应设备建立链接 
        deviceId: this.data.deviceId,
        success: (res) => {
          console.log('device services:', res.services)
          this.setData({
            ToothServices: res.services
          })
        }
      })
    }
    
  },
  getCharacteristics: function (e) {
    let index = e.currentTarget.dataset.num;
    console.log('index:' + index)

    let serviceId = this.data.ToothServices[index].uuid;

    console.log('serviceId:' + serviceId)

    wx.navigateTo({
      url: '../showbluetooth/showbluetooth?deviceId=' + this.data.deviceId + '&serviceId=' + serviceId
    })
  },

  closeBluetooth: function () {
    if (this.data.isblue) {
      console.log('关闭蓝牙')
      wx.closeBluetoothAdapter({
        success: (res) => {
          console.log(res)
        }
      })
    }
    
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
    wx.closeBLEConnection({
      deviceId: this.data.deviceId,
      success: (res) => {
        console.log(res)
        console.log('关闭蓝牙')
        wx.closeBluetoothAdapter({
          success: (res1) => {
            console.log(res)
          }
        })
      }
    })
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
  
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
  
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  }
})