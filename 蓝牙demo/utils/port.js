//Get请求
function rquestGet(url, body) {
  console.log(url)
  return new Promise((resolve, reject) => {
    wx.request({
      url: url,
      method: 'get',
      data: body,
      dataType: 'json',
      header: {
        'content-type': 'application/json' // 默认值
      },
      success: (res) => {
        resolve(res.data);
      },
      fail: (res) => {
        reject(res.data);
      }
    })
  })
}

//Post请求
function rquestPost(url, body) {
  console.log(url)
  console.log(body)
  return new Promise((resolve, reject) => {
    wx.request({
      url: url,
      method: 'post',
      data: body,
      dataType: 'json',
      header: {
        'content-type': 'application/json' // 默认值
      },
      success: (res) => {
        resolve(res.data);
      },
      fail: (res) => {
        reject(res.data);
      }
    })
  })
}

module.exports = {
  rquestGet: rquestGet,
  rquestPost: rquestPost
}