// pages/showbluetooth/showbluetooth.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    deviceId: '',
    serviceId: '',
    characteristics: []
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.setData({
      deviceId: options.deviceId,
      serviceId: options.serviceId
    })
    console.log('deviceId:' + options.deviceId + 'serviceId:' + options.serviceId)
    wx.getBLEDeviceCharacteristics({
      // 这里的 deviceId 需要已经通过 createBLEConnection 与对应设备建立链接
      deviceId: options.deviceId,
      // 这里的 serviceId 需要在上面的 getBLEDeviceServices 接口中获取
      serviceId: options.serviceId,
      success: (res) => {
        console.log('device getBLEDeviceCharacteristics:', res.characteristics)
        this.setData({
          characteristics: res.characteristics
        })
      }
    })
  },
  // ArrayBuffer转16进度字符串示例
  ab2hex: function (buffer) {
    var hexArr = Array.prototype.map.call(
      new Uint8Array(buffer),
      function (bit) {
        return ('00' + bit.toString(16)).slice(-2)
      }
    )
        return hexArr.join('');
  },
  getCharacteristicValue: function (e) {
    let index = e.currentTarget.dataset.num;
    console.log('index:' + index)
    let characteristicId = this.data.characteristics[index].uuid
    if (this.data.characteristics[index].properties.read) {     //可以进行读取操作
      console.log('开始进行读取操作：')

      wx.onBLECharacteristicValueChange((ValueChange) => {       //监听低功耗蓝牙设备的特征值变化。必须先启用notify接口
        console.log(`characteristic ${ValueChange.characteristicId} has changed, now is ${ValueChange.value}`)
        console.log(this.ab2hex(ValueChange.value))
      })

      wx.readBLECharacteristicValue({
        // 这里的 deviceId 需要已经通过 createBLEConnection 与对应设备建立链接  [**new**]
        deviceId: this.data.deviceId, 
        // 这里的 serviceId 需要在上面的 getBLEDeviceServices 接口中获取
        serviceId: this.data.serviceId,
        // 这里的 characteristicId 需要在上面的 getBLEDeviceCharacteristics 接口中获取
        characteristicId: characteristicId,
        success: (res) => {
          console.log('读取操作成功:' + res.errMsg)
        }
      })
    }
    if (this.data.characteristics[index].properties.write) {     //可以进行写入操作
      // 向蓝牙设备发送一个0x00的16进制数据
      let buffer = new ArrayBuffer(1)
      let dataView = new DataView(buffer)
      dataView.setUint8(0, 0)

      wx.writeBLECharacteristicValue({
        // 这里的 deviceId 需要在上面的 getBluetoothDevices 或 onBluetoothDeviceFound 接口中获取
        deviceId: this.data.deviceId,
        // 这里的 serviceId 需要在上面的 getBLEDeviceServices 接口中获取
        serviceId: this.data.serviceId,
        // 这里的 characteristicId 需要在上面的 getBLEDeviceCharacteristics 接口中获取
        characteristicId: characteristicId,
        // 这里的value是ArrayBuffer类型
        value: buffer,
        success: function (res) {
          console.log('写入操作成功：' + res.errMsg)
        }
      })       
    }
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

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
  
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