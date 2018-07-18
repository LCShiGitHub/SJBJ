//
//  bastviewCroller.swift
//  first_swift
//
//  Created by kkqb on 16/7/22.
//  Copyright © 2016年 kkqb. All rights reserved.
//

import UIKit

class BastviewCroller: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var index :NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if index == nil {
            index = 1;
            
            setFirstUI()
        }
        
        self.title = "第"+String(index)+"页"
        
        let loat1 = Float(arc4random()) / 0xFFFFFFFF
        let loat2 = Float(arc4random()) / 0xFFFFFFFF
        let loat3 = Float(arc4random()) / 0xFFFFFFFF
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: loat1, green: loat2, blue: loat3, alpha: 1)
        
        setUI()

    }
    
    func setUI() {
        
        let titles = ["上一页","下一页"]
        
        
        for index1 in 0..<2 {
            
            let button = UIButton(frame: CGRect(x: 100, y: 100 + 80*index1, width: (Int(self.view.bounds.size.width - 200)), height: 40))
            
            button.setTitle(titles[index1], for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.tag = index1 + 1
            button.addTarget(self, action: #selector(uibuttonClick(cender:)), for: .touchUpInside)
            
            self.view.addSubview(button)
            
        }
    }
    
    @objc func uibuttonClick(cender:UIButton) {
        
//        print("--------\(cender.tag)")
        
        switch cender.tag {
        case 2:
            let VC = BastviewCroller()
            
            VC.index = self.index + 1
            
            self.navigationController?.pushViewController(VC, animated: true)
            
        default:
            
            let _ = self.navigationController?.popViewController(animated: true)
        
        }
        
    }
    
    func setFirstUI() {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 250 , width: self.view.bounds.size.width ,height: 300), style: .plain)
        
        tableView.backgroundColor = UIColor.green
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CELL")
        
        self.view.addSubview(tableView)
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")! as UITableViewCell

        cell.textLabel?.text = "cell \(indexPath.row)"
        
        cell.selectionStyle = .none
        
        let float = Float(arc4random()) / 0xFFFFFFFF
        
        cell.backgroundColor = UIColor.init(colorLiteralRed: float, green: float, blue: float, alpha: 1)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = succedViewController()
        
        VC.cellRow = String(indexPath.row)
        
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
