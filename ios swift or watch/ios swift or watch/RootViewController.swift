//
//  RootViewController.swift
//  ios swift or watch
//
//  Created by kkqb on 2016/12/1.
//  Copyright © 2016年 swift_wach. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "swift"
        
        self.view.backgroundColor = UIColor.red
        
        setUi()
        
        
    }
    func setUi() {
        let label = UILabel.init(frame: CGRect(x:0, y:100, width:200, height: 30))
        
        label.text = "label label"
        label.textColor = UIColor.green
        label.backgroundColor = UIColor.lightGray
//        let fons:NSArray = UIFont.familyNames as NSArray
//        label.font = UIFont.init(name: fons[5] as! String, size: 16)
        
        label.font = UIFont.systemFont(ofSize: 20)
        
        label.textAlignment = .center
        
        label.isUserInteractionEnabled = true
        
        self.view.addSubview(label)
        
        let view1 = UIView.init(frame: CGRect(x:100, y:150, width:100, height:50))
        view1.backgroundColor = UIColor.white
//        view1.backgroundColor(UIColor.blue)
        view1.layer.cornerRadius = 5.0
        view1.layer.masksToBounds = true
        self.view.addSubview(view1)
        
        let addBtn = UIButton.init(type: .custom)
        
        addBtn.frame = CGRect(x:0, y:10, width:100, height:30)
        
        addBtn.setTitle("button", for: .normal)
        addBtn.setTitle("button", for: .highlighted)
        addBtn.setTitleColor(UIColor.red, for: .normal)
        addBtn.setTitleColor(UIColor.green, for: .highlighted)
        
        
        addBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        
        view1.addSubview(addBtn)
        
        let graht = UIGestureRecognizer.init(target: self, action: #selector(graClick))
        
        
        
        label.addGestureRecognizer(graht)
        
       
        
    
        
    }
    
    @objc func btnClick() {
        print("点击了按钮")
    }
    
    @objc func graClick() {
        print("触摸了label")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
