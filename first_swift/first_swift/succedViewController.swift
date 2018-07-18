//
//  succedViewController.swift
//  first_swift
//
//  Created by kkqb on 2016/12/16.
//  Copyright © 2016年 kkqb. All rights reserved.
//

import UIKit

class succedViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    var cellRow : String!
    
    var scrollView : UIScrollView!
    
    var ordindex : IndexPath!
    
    var intmW : Double!
    
    var views : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "collectView " + cellRow
        
        self.view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        intmW = Double(self.view.bounds.size.width - 48.0) / 5.0
        
        layout.itemSize = CGSize(width: intmW, height: 40)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = .init(top: 0, left: 8.0, bottom: 0, right: 8.0)
        
        layout.minimumLineSpacing = 8.0
        
        let WIDTH = self.view.bounds.size.width
        let HEIGHT = self.view.bounds.size.height
        
        views = NSMutableArray()
        
        let collectView = UICollectionView.init(frame: CGRect(x:0 ,y:200 ,width:WIDTH ,height:50), collectionViewLayout:layout)
        
        collectView.backgroundColor = UIColor.green
        
        collectView.delegate = self
        collectView.dataSource = self
        
        collectView.showsHorizontalScrollIndicator = false
        
//        collectView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "COLLCELL")
        
        collectView.register(UINib.init(nibName: "succedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "succedCollectionViewCell")
        
        self.view.addSubview(collectView)
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 280, width: WIDTH, height: HEIGHT - 280))
        
        scrollView.contentSize = CGSize(width: WIDTH * 3, height: HEIGHT - 280)
        
        scrollView.delegate = self
        
        scrollView.isPagingEnabled = true
        
        scrollView.contentOffset = CGPoint(x: WIDTH, y: 0)
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.tag = 10
        
        self.view.addSubview(scrollView)
        
        for index : Int in 0..<3 {
            
            let bgview = UIView(frame: CGRect(x: CGFloat(index) * WIDTH, y: 0, width: WIDTH, height: HEIGHT -  280))
            
//            let loat1 = Float(arc4random()) / 0xFFFFFFFF
//            let loat2 = Float(arc4random()) / 0xFFFFFFFF
//            let loat3 = Float(arc4random()) / 0xFFFFFFFF
//            
//            bgview.backgroundColor = UIColor.init(colorLiteralRed: loat1, green: loat2, blue: loat3, alpha: 1)
            
            let label = UILabel(frame: CGRect(x: 100, y: 80, width: WIDTH - 200, height: 40))
            
            
            
            switch index {
            case 0:
                bgview.backgroundColor = UIColor.red
                
                label.text = "第3屏 共三屏"
                
            case 1:
                bgview.backgroundColor = UIColor.green
                
                label.text = "第1屏 共三屏"
                
            default:
                bgview.backgroundColor = UIColor.blue
                
                label.text = "第2屏 共三屏"
            }
            
           
            
            label.textColor = UIColor.white
            
            label.font = UIFont.systemFont(ofSize: 20)
            
            bgview.addSubview(label)
            
            views.add(bgview)
            
            scrollView.addSubview(bgview)
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : succedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "succedCollectionViewCell", for: indexPath) as! succedCollectionViewCell
        
       
        if indexPath.row % 2 == 0 {

            cell.backgroundColor = UIColor.red
            
        }else{
            
            cell.backgroundColor = UIColor.black
        }
        
//        cell.selectedBackgroundView?.backgroundColor = UIColor.blue
        
        cell.textLabel.text = "第\(indexPath.row + 1)页"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let _left = Double(indexPath.row) * (intmW + 8.0) + intmW/2.0 + 8.0    //cell中心点到左边的距离
        
//        print("需要移动的----\(_left - Double(collectionView.frame.size.width / 2)) --- \(collectionView.contentOffset.x)")
        
        if _left > Double(collectionView.frame.size.width / 2) &&  _left < Double(20*(intmW + 8.0) + 8.0) - Double(collectionView.frame.size.width / 2) {
            
//            print("中间")
            
            collectionView.setContentOffset(CGPoint(x: _left - Double(collectionView.frame.size.width / 2), y: 0), animated: true)
            
        }else{
            if _left < Double(collectionView.frame.size.width / 2) + 3.0 {
                
//               print("最左边")
                
               collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                
                
            }
            if _left > Double(20*(intmW + 8.0) + 8.0) - Double(collectionView.frame.size.width / 2) - 3.0 {
                
//                print("最右边")
                
                collectionView.setContentOffset(CGPoint(x: 20*(self.intmW + 8.0) + 8.0 - Double(collectionView.frame.size.width), y: 0), animated: true)
                
            }
        }
        
        
        if ordindex != nil {
            let cell = collectionView.cellForItem(at: ordindex)
            
            if ordindex.row % 2 == 0 {
                
                cell?.backgroundColor = UIColor.red
                
            }else{
                
                cell?.backgroundColor = UIColor.black
            }
            
        }
        
        let cell:succedCollectionViewCell = collectionView.cellForItem(at: indexPath) as! succedCollectionViewCell
        
        cell.backgroundColor = UIColor.blue
        
        ordindex = indexPath
        
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("正在滑动")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("开始滑动")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("手指松开")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("停止滑动")
        
        let W = scrollView.frame.size.width
        
        
        if scrollView.tag == 10 {
            
            if scrollView.contentOffset.x > scrollView.frame.size.width + 20 {    //左滑
                
                let firstView = views[0] as! UIView
                
                views.removeObject(at: 0)
                
                views.add(firstView)
                
            }
            
            if scrollView.contentOffset.x < scrollView.frame.size.width - 20 {    //右滑
                
                let firstView = views[2] as! UIView
                
                views.insert(firstView, at: 0)
                
                views.removeLastObject()
                
            }
            
            for index in 0 ... 2 {
                
                let bgview = views[index] as! UIView
                
                var rect = bgview.frame;
                
                rect.origin.x = CGFloat(index) * W
                
                bgview.frame = rect
                
            }
            
            
            scrollView.setContentOffset(CGPoint(x:scrollView.frame.size.width ,y:0), animated: false)
            
            
            
            
        }
        
        
        
    }

}
