//
//  ViewController.swift
//  first_swift
//
//  Created by kkqb on 16/7/21.
//  Copyright © 2016年 kkqb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("hello word!")
        
        var name:String = "liu cong shi"
        
        name = "liu cong shi"
        
        print(name + "hello word")
        
        let teg:Float = 78.000
        
        print(teg)
        
        let tag = name+" "+String(teg) //类型转换
        
        print(tag)
        
        let f:String = "my name \(teg) "  //有一种更简单的把值转换成字符串的方法：把值写到括号中，并且在括号之前写一个反斜杠
        
        
        print(f + name)
        
        
        var arrs = ["123","234","345","456"]
        
        arrs[3] = "111"
        
        
        
        print(arrs)
        
        let count:Int = arrs.count
        
        print(count)
        
        arrs += ["I" ,"am" ,"Kenshin"] //追加元素
        
        print("a.count=\(arrs.count)") //结果：a.count=7
        
        arrs[3...5]=["I","Love","Swift"] //修改元素,但是注意无法用这种方式添加元素
        
        arrs.insert("New", at: 5) //插入元素：hello world! I Love New Swift
        
        print(arrs)
        
        arrs.remove(at: 5) //删除指定元素
    
        arrs.insert("liucongshi", at: 6)
        
        print(arrs)
        
//        var str1 = "hello world."
//        var range="a"..."z"
//        for t in str1 {
//            if range.contains(String(t)) {
//                print(t) //结果：helloworld
//            }
//        }
        
        /**
         * 溢出运算符
         */
        var a=UInt8.max //a=255
        //var b:UInt8=a+1 //注意b会出现溢出,此句报错
        
        //下面使用溢出运算符，结果为：0，类似的还有&-、&*、&/
        //使用溢出运算符可以在最大值和最小值之前循环而不会报错
        var b:UInt8=a &+ 1
        
        
        let dic = ["1":"liucongshi","2":"qwe"]
        
//        let count1 = dic.keys.count
        
        let arr1s:Array = Array(dic.values)
        
        print(arr1s)
        
        var dict = Dictionary<String,Float>()
 
        dict = ["fa":9.9]
        
        print(dict)
        
        for c in arr1s {
            print(c)
        }
        
        let interestingNumbers = [
            "Prime": [2, 3, 5, 7, 11, 13],
            "Fibonacci": [1, 100, 2, 3, 5, 8],
            "Square": [1, 4, 9, 16, 25],
            ]
        var largest = 0
        for (kind, numbers) in interestingNumbers { //你可以使用for-in来遍历字典，需要两个变量来表示每个键值对。
            for number in numbers {
                if number > largest {
                    largest = number
                }
            }
            print(kind)
        }
        print(largest)
        
        var n = 2
        while n < 100 {
            n = n * 2
        }
        print(n)
        
        var add = 0
        
        for i in 0...9 {   //使用..创建的范围不包含上界，如果想包含的话需要使用...
            add += i
        }
        print(add)
        
        

        //使用func来声明一个函数，使用名字和参数来调用函数。使用->来指定函数返回值
        func letgot (_ name:String,tag:Int) ->String{
            let print = name + String(tag)
            return print
        }
        
        let print1 = letgot("liu cong shi", tag: 24)
        print(print1)
        
        //使用一个元组来返回多个不同类型的值
        func yuanzu() ->(String,Int,NSNumber){
            return ("1233",12,23.0)
        }
        
        print(yuanzu())
        
        
        //函数的参数数量是可变的，用一个数组来获取它们
        func kebian(_ numbers:Int...)->Float{
            var nums = 0
            for num in numbers {
                nums += num
            }
            let count = numbers.count
            
            let pingjun:Float = Float(nums/count)
            return pingjun
        }
        print(kebian(12,12,21,28))
        
        //函数可以嵌套。被嵌套的函数可以访问外侧函数的变量，你可以使用嵌套函数来重构一个太长或者太复杂的函数。
        
        func qietao(_ tag:Int) -> Int{
            var y = 1
            var x = tag
            
            func qiuchengji () -> Int{
                while y < tag {
                    x *= 10
                    y += 1   //swift 里面并没有自增自减语句
                }
                return x
            }
            
            let z = qiuchengji()
            
            return z
        }
        print(qietao(10))
        
        
        //函数是一等公民，这意味着函数可以作为另一个函数的返回值
        func makeIncrementer() -> ((Int) -> Int) {
            func addOne(_ number: Int) -> Int {
                return 1 + number
            }
            return addOne
        }
        let increment = makeIncrementer()
        print(increment(7))

        
        //函数也可以当做参数传入另一个函数
        func hasAnyMatches(_ list1: [Int], condition: (Int) -> Bool) -> (Int,[Int]) {
            var count = 0
            var index:Int = 0
            var arrs = [Int]()  //定义一个数组
            
            for item in list1 {
                if condition(item) {
                    count += 1
                    arrs += [index]  //追加元素到数组
                
                }
                index += 1
//                index ++
                
            }
            return (count,arrs)
        }
        func lessThanTen(_ number: Int) -> Bool {
            return number < 10
        }
        let numbers = [20, 19, 10, 12, 23, 3, 2, 1]   //判断数组中比10小的数 并输出下标
        
        let yes = hasAnyMatches(numbers, condition: lessThanTen)
        
        print(yes)
        
        class ViewController{   //使用class和类名来创建一个类。类中属性的声明和常量、变量声明一样，唯一的区别就是它们的上下文是类。同样，方法和函数声明也一样
            
            var name = "liu cong shi"
            
            var tag = 18
            
            var label = UILabel()
            
            
            func getnameandtag(_ name:String,tag:Int) -> (Bool,String) {  //false == YES  true == NO
                
                if tag > 20 {
                    return (false,name)
                }else{
                    return (true,name+String(tag))
                }
                
            }
            
        }
        
        let vc = ViewController()
        let jieguo = vc.getnameandtag(vc.name, tag: vc.tag)
       
        if jieguo.0 {
            print("yes \(jieguo.1)")
        }else{
            print("no \(jieguo.1)")
        }
        
        vc.label.frame = CGRect(x: 100, y: 100, width: 100, height: 30);
        vc.label.text = "swift swift"
        vc.label.backgroundColor = .lightGray
        vc.label.textAlignment = .center
        self.view.addSubview(vc.label)
        
        //子类的定义方法是在它们的类名后面加上父类的名字，用冒号分割。创建类的时候并不需要一个标准的根类，所以你可以忽略父类。
        
        //子类如果要重写父类的方法的话，需要用override标记——如果没有添加override就重写父类方法的话编译器会报错。编译器同样会检测override标记的方法是否确实在父类中。
        
        //使用enum来创建一个枚举。就像类和其他所有命名类型一样，枚举可以包含方法
        
        //使用struct来创建一个结构体。结构体和类有很多相同的地方，比如方法和构造器。它们结构体之间最大的一个区别就是 结构体是传值，类是传引用
        
        //使用!来获取一个不存在的可选值会导致运行时错误。使用!来强制解析值之前，一定要确定可选包含一个非nil的值。
        
        //Swift 的nil和 Objective-C 中的nil并不一样。在 Objective-C 中，nil是一个指向不存在对象的指针。在 Swift 中，nil不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选都可以被设置为nil，不只是对象类型
        
        
        let max = uint_fast64_t.max
        let max1 = uint_fast32_t.max
        let max2 = uint_fast16_t.max
        let max3 = uint_fast8_t.max
        
        let max42 = intmax_t.max
        
        
        print(max,max1,max2,max3,max42)
        
        let string = ""
        if string.isEmpty {
            print("\"或许会更好\"")
        }else{
            print("\"你都知道的\"")
            
        }
        
        //通过调用字符串的 hasPrefix/hasSuffix 方法来检查字符串是否拥有特定前缀/后缀。两个方法均需要以字符串作为参数传入并传出 Boolean 值。两个方法均执行基本字符串和前缀/后缀字符串之间逐个字符的比较操作。
        
        
        
        class MyClass {
            var name = "liu cong shi"
            var age = "24"
            var ext = "nan"
            
            func myClass(_ myage:NSString) -> NSString {
//                print(myage)
                return myage
            }
            
        }
        
        let age1 = MyClass().age
        print(MyClass().myClass(age1 as NSString))
        
        
//        let bastVC:bastviewCroller = bastviewCroller()
        
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}

