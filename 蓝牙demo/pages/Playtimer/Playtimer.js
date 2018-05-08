// pages/Playtimer/Playtimer.js
var myTimer;
var timerCanvas;
var count;
Page({

  /**
   * 页面的初始数据
   */
  data: {
    dateText: '00:00:00',
    shi: 0,
    feng: 0,
    miao: 0,
    data: [],
    showX: 0,
    showY: 0,
    showindex: -1,
    imgs: []
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    count = 0
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    timerCanvas = wx.createCanvasContext('PlaytimerCanvas');
  },
  setCanvas() {
    timerCanvas.setFillStyle('#5F9EA0')
    timerCanvas.fillRect(0, 0, 360, 200)
    // 设置描边颜色
    timerCanvas.setStrokeStyle("#7cb5ec");
    // 设置线宽
    timerCanvas.setLineWidth(4);
    timerCanvas.moveTo(-15, 150 - this.data.data[0]);
    for (var i = 1; i < this.data.data.length; i++) {
      timerCanvas.lineTo(30 * i - 15, 150 - this.data.data[i]);
    }
    timerCanvas.stroke();
    timerCanvas.beginPath();
    // 设置描边颜色
    timerCanvas.setStrokeStyle("#7cb5ec");
    timerCanvas.setLineWidth(6);
    // 设置填充颜色
    timerCanvas.setFillStyle("#7cb5ec");
    if(this.data.data.length > 0) {
      timerCanvas.moveTo(-12, 150 - this.data.data[0]);
      // 绘制圆形区域
      timerCanvas.arc(-15, 150 - this.data.data[0], 3, 0, 2 * Math.PI, false);
    }
    for (var i = 1; i < this.data.data.length; i++) {
      timerCanvas.moveTo(-12 + 30 * i, 150 - this.data.data[i]);
      // 绘制圆形区域
      timerCanvas.arc(-15 + 30 * i, 150 - this.data.data[i], 3, 0, 2 * Math.PI, false);
    }
    timerCanvas.closePath();
    // 对当前路径进行描边
    timerCanvas.stroke();
    timerCanvas.draw()
    setTimeout((res) => {
      wx.canvasToTempFilePath({
        x: 0,
        y: 0,
        width: 360,
        height: 200,
        destWidth: 360,
        destHeight: 200,
        canvasId: 'PlaytimerCanvas',
        success: (res) => {
          console.log(res.tempFilePath)
          var newimgs = this.data.imgs
          newimgs.unshift(res.tempFilePath)
          console.log(newimgs)
          this.setData({
            imgs: newimgs
          })
        }
      })
    }, 1000)
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
  star() {
    console.log('star')
    if (myTimer === undefined) {
      myTimer = setInterval ((res) => {
        var newShi = this.data.shi
        var newFen = this.data.feng
        var newMiao = this.data.miao + 1
        var shiStr = ''
        var fenStr = ''
        var miaoStr = ''
        if (newMiao === 60) {
          newMiao = 0
          newFen += 1
          if(newFen === 60) {
            newFen = 0
            newShi += 1 
          }
        }
        if(newShi < 10){
          shiStr = '0' + newShi.toString()
        } else {
          shiStr = newShi.toString()
        }
        if (newFen < 10) {
          fenStr = '0' + newFen.toString()
        } else {
          fenStr = newFen.toString()
        }
        if (newMiao < 10) {
          miaoStr = '0' + newMiao.toString()
        } else {
          miaoStr = newMiao.toString()
        }
        this.setData({
          dateText: shiStr + ':' + fenStr + ':' + miaoStr,
          shi: newShi,
          feng: newFen,
          miao: newMiao
        })
      }, 1000)
    }
  },
  suspend() {
    console.log('suspend')
    clearInterval(myTimer)
    myTimer = undefined
  },
  end() {
    console.log('end')
    clearInterval(myTimer)
    myTimer = undefined
    this.setData({
      dateText: '00:00:00',
      shi: 0,
      feng: 0,
      miao: 0
    })
  },
  touchstart(e) {
    console.log('x:' + e.touches[0].x)
    console.log('y:' + e.touches[0].y)
    let touthX = e.touches[0].x
    let touthY = e.touches[0].y
    var touthIndex = -1
    for(var i = 0; i < this.data.data.length; i ++) {
      if ((touthX > i * 30 - 19) && (touthX < i * 30 - 9) && (144 - touthY) < this.data.data[i] && (156 - touthY) >  this.data.data[i] ) {
        console.log('触摸到了')
        touthIndex = i
        break
      }
    }
    let newData = this.data.data
    var XX = 0
    var YY = 0
    if(touthIndex !== -1) {
      console.log('触摸到点-----' + touthIndex)
      if  (touthIndex === 0) {
        XX = 0
        if (newData[0] < newData[1]) {
          YY = 150 - newData[0]
        } else {
          YY = 150 - newData[0]
        }
      } else if (touthIndex === newData.length - 1) {
        if (newData[newData.length - 2] < newData.length - 1) {

        } else {

        }
      } else {

      }
      console.log('XX:' + XX + 'YY:' + YY)
      this.setData({
        showindex: touthIndex,
        showX: XX,
        showY: YY
      })
    } else {
      console.log('没有触摸到点')
    }
  },
  randomly() {
    var newdatas = []
    if(count !== 0){
      for (var i = 0; i < 12; i++) {
        let dandom = parseInt(100 * Math.random());// 输出0～10之间的随机整数
        newdatas.push(dandom)
      }
      newdatas.push(this.data.data[0])
      newdatas.push(this.data.data[1])
      console.log(newdatas)
      this.setData({
        data: newdatas
      })
    } else {
      for (var i = 0; i < 13; i++) {
        let dandom = parseInt(100 * Math.random());// 输出0～10之间的随机整数
        newdatas.push(dandom)
      }
      console.log(newdatas)
      this.setData({
        data: newdatas
      })
    }
    count ++
    this.setCanvas()
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