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
let  version = (UIDevice.currentDevice().systemVersion as NSString).floatValue

// 屏幕宽度
let ScreenHeight : CGFloat = UIScreen.mainScreen().bounds.height

// 屏幕高度
let ScreenWidth : CGFloat = UIScreen.mainScreen().bounds.width

// 默认图片
let defaultImg = UIImage(named: "photo_define")

// NSUserDefault
let userDefault = NSUserDefaults.standardUserDefaults()

// 通知中心
let notice = NSNotificationCenter.defaultCenter()

//判断是不是plus
let currentModeSize = UIScreen.mainScreen().currentMode?.size
let isPlus = UIScreen.instancesRespondToSelector("currentMode") ? CGSizeEqualToSize(CGSizeMake(1242, 2208), currentModeSize!) : false

//判断字符串是否为空
func trimString(str str:String)->String{
    let nowStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
    return nowStr
    }

//去除空格和回车
func trimLineString(str str:String)->String{
    let nowStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    return nowStr
    }

//根据键盘监控  获取键盘高度
func getKeyBoardHeight(aNotification aNotification:NSNotification)->CGFloat{
    let uInfo   = aNotification.userInfo as NSDictionary!
    let avalue = uInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue
    let keyrect : CGRect = avalue.CGRectValue()
    let keyheight : CGFloat = keyrect.size.height;
    return keyheight
    }

//获取目录下存储的json文件并解析为集合
func getNativeJson(filename filename : String,fileext : String)->AnyObject{
    let pathsBun = NSBundle.mainBundle()
    let paths = pathsBun.pathForResource(filename, ofType : fileext)
    let content : NSData = try! NSData(contentsOfFile: paths!, options : .DataReadingMappedIfSafe)
    var returneddata: AnyObject?
    do {
        returneddata = try NSJSONSerialization.JSONObjectWithData(content as NSData, options:NSJSONReadingOptions.MutableContainers)
    } catch let error as NSError {
        returneddata = nil
    }
    return returneddata!
}

//消息提醒
func showAlertView(title title:String,message:String){
    let alert = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButtonWithTitle("好")
    alert.show()
}

//获取本地存储数据
func get_userDefaults(key key : String)->AnyObject?{
    var saveStr : AnyObject! = userDefault.objectForKey(key)
    saveStr = (saveStr == nil) ? "" : saveStr
    return saveStr
}

//存储数据
func save_userDefaults(key key : String,value:AnyObject?){
    userDefault.setObject(value!, forKey:key)
}

//字符串转数组
func stringToArray(str str:String)->NSArray{
    var dataArray:[String] = []
    for _ in str.characters{
        dataArray.append("/(items)")
        }
    return dataArray
    }








