//
//  File.swift
//  LongPratice
//
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import Foundation
import UIKit


// 当前系统版本 
let  version = (UIDevice.current.systemVersion as NSString).floatValue

// 屏幕宽度
let ScreenHeight : CGFloat = UIScreen.main.bounds.height

// 屏幕高度
let ScreenWidth : CGFloat = UIScreen.main.bounds.width

// 默认图片
let defaultImg = UIImage(named: "photo_define")

// NSUserDefault
let userDefault = UserDefaults.standard

// 通知中心
let notice = NotificationCenter.default

//判断是不是plus
let currentModeSize = UIScreen.main.currentMode?.size
let isPlus = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo(currentModeSize!) : false

//判断字符串是否为空
func trimString(str:String)->String{
    let nowStr = str.trimmingCharacters(in: CharacterSet.whitespaces);
    return nowStr
    }

//去除空格和回车
func trimLineString(str:String)->String{
    let nowStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return nowStr
    }

//根据键盘监控  获取键盘高度
func getKeyBoardHeight(aNotification:Notification)->CGFloat{
    let uInfo   = aNotification.userInfo as NSDictionary!
    let avalue = uInfo?["UIKeyboardFrameEndUserInfoKey"] as! NSValue
    let keyrect : CGRect = avalue.cgRectValue
    let keyheight : CGFloat = keyrect.size.height;
    return keyheight
    }

//获取目录下存储的json文件并解析为集合
//func getNativeJson(filename : String,fileext : String)->AnyObject{
//    let pathsBun = Bundle.main
//    let paths = pathsBun.path(forResource: filename, ofType : fileext)
//    let content : Data = try! Data(contentsOf: URL(fileURLWithPath: paths!), options : .mappedIfSafe)
//    var returneddata: AnyObject?
//    do {
//        returneddata = try JSONSerialization
////        returneddata = try JSONSerialization.jsonObject(with: content as Data, options:JSONSerialization.ReadingOptions.mutableContainers)
//    } catch let error as NSError {
//        returneddata = nil
//    }
//    return returneddata!
//}

//消息提醒
func showAlertView(title:String,message:String){
    let alert = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButton(withTitle: "好")
    alert.show()
}

//获取本地存储数据
//func get_userDefaults(key : String)->AnyObject?{
//    var saveStr : AnyObject! = userDefault.object(forKey: key) as AnyObject!
//    saveStr = (saveStr == nil) ? "" : saveStr
//    return saveStr
//}

//存储数据
func save_userDefaults(key : String,value:AnyObject?){
    userDefault.set(value!, forKey:key)
}

//字符串转数组
func stringToArray(str:String)->NSArray{
    var dataArray:[String] = []
    for _ in str.characters{
        dataArray.append("/(items)")
        }
    return dataArray as NSArray
    }








