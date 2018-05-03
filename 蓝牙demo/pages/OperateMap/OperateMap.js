// pages/OperateMap/OperateMap.js
const port = require('../../utils/port.js')

var homeMap;

Page({

  /**
   * 页面的初始数据
   */
  data: {
    polyline: [{
      points: [],
      color: "#FF0000DD",
      width: 2,
      dottedLine: false
    }] 
  },
  regionchange(e) {
    console.log(e.type)
  },
  controltap(e) {
    console.log(e.controlId)
  },
  showPath(e) {
    console.log('开始请求')
    let body = {
      origin: '28.159857,113.027258',
      destination: '28.105962,113.036457',
      ak: 'l51Pp7gkTg8aqPNIgUh3UlClq8NBBeza'
    };
    port.rquestGet('http://api.map.baidu.com/direction/v2/transit', body)
      .then(res => {
        let steps = res.result.routes[1].steps
        console.log(steps);
        var paths = [];
        for (var i = 0; i < steps.length; i ++){
          // console.log(steps[i][0].path);
          for (var k = 0; k < steps[i].length; k++) {
            var patharr = steps[i][k].path.split(";");
            for (var j = 0; j < patharr.length; j++) {
              var arr = patharr[j].split(",");
              let poly = {
                longitude: arr[0],
                latitude: arr[1]
              }
              paths.push(poly)
            }
          }
        }
        this.setData({
          polyline: [{
            points: paths,
            color: "#FF0000DD",
            width: 2,
            dottedLine: false
          }] 
        })
        
        

      }).catch(res => {
        console.log(res)
      })
    
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
    homeMap = wx.createMapContext('map');
    this.checkSettingStatu();
  },
  checkSettingStatu: function () {
    wx.getSetting({
      success: res1 => {
        console.log(res1.authSetting);
        let authSetting = res1.authSetting;
        if (authSetting['scope.userLocation'] === false) {    //没有授权
          wx.showModal({
            title: '用户未授权',
            content: '如需正常使用定位，请按确定并在授权管理中选中“地理位置”，然后点按确定后返回即可正常使用。',
            showCancel: false,
            success: res2 => {
              if (res2.confirm) {
                wx.openSetting({
                  success: res3 => {
                    console.log('openSetting success', res3.authSetting);
                    let Auth = res3.authSetting
                    if (Auth['scope.userLocation'] === true) {
                      this.wxgetLocation()
                    } else {
                      this.checkSettingStatu()
                    }
                  }
                });
              }
            }
          })
        } else if (authSetting['scope.userLocation'] === undefined) {
          this.wxgetLocation()
        } else {
          this.wxgetLocation()
        }
      }
    })
  },
  wxgetLocation: function() {
    wx.getLocation({
      type: 'gcj02', //返回可以用于wx.openLocation的经纬度
      success: (center) => {
        homeMap.moveToLocation({         //移动到当前定位的位置
          success: (res) => {
            console.log('success')
          }
        })
      },
      fail: (res) => {
        this.checkSettingStatu()
      }
    })
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