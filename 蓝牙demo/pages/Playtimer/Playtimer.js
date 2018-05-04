// pages/Playtimer/Playtimer.js
var myTimer;
var timerCanvas;
Page({

  /**
   * 页面的初始数据
   */
  data: {
    dateText: '00:00:00',
    shi: 0,
    feng: 0,
    miao: 0,
    data: []
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
    timerCanvas = wx.createCanvasContext('PlaytimerCanvas');
  },
  setCanvas() {
    // 设置描边颜色
    timerCanvas.setStrokeStyle("#7cb5ec");
    // 设置线宽
    timerCanvas.setLineWidth(4);
    timerCanvas.moveTo(10, 150 - this.data.data[0]);
    for (var i = 1; i < this.data.data.length; i++) {
      timerCanvas.lineTo(30 * i + 10, 150 - this.data.data[i]);
    }
    timerCanvas.stroke();
    timerCanvas.beginPath();
    // 设置描边颜色
    timerCanvas.setStrokeStyle("#7cb5ec");
    timerCanvas.setLineWidth(6);
    // 设置填充颜色
    timerCanvas.setFillStyle("#7cb5ec");
    if(this.data.data.length > 0) {
      timerCanvas.moveTo(10 + 3, 150 - this.data.data[0]);
      // 绘制圆形区域
      timerCanvas.arc(10, 150 - this.data.data[0], 3, 0, 2 * Math.PI, false);
    }
    for (var i = 1; i < this.data.data.length; i++) {
      timerCanvas.moveTo(10 + 3 + 30 * i, 150 - this.data.data[i]);
      // 绘制圆形区域
      timerCanvas.arc(10 + 30 * i, 150 - this.data.data[i], 3, 0, 2 * Math.PI, false);
    }
    timerCanvas.closePath();
    // 对当前路径进行描边
    timerCanvas.stroke();
    timerCanvas.draw()
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
      if ((touthX > i * 30 + 6) && (touthX < i * 30 + 16) && (144 - touthY) < this.data.data[i] && (156 - touthY) >  this.data.data[i] ) {
        console.log('触摸到了')
        touthIndex = i
        break
      }
    }
    if(touthIndex !== -1) {
      console.log('触摸到点-----' + touthIndex)
    } else {
      console.log('没有触摸到点')
    }
  },
  randomly() {
    var newdata = []
    for(var i = 0; i < 11; i ++) {
      let dandom = parseInt(100 * Math.random());// 输出0～10之间的随机整数
      newdata.push(dandom)
    }
    console.log(newdata)
    this.setData({
      data: newdata
    })
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