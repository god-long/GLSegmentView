//
//  SegmentSlideView.swift
//  LongPratice
//
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

protocol GLSegmentSlideVCDelegate{
    /**
    点击某个控件代理执行的方法
    
    - parameter index: 点击控件的下标
    */
    func didSelectSegment(index : Int)
}


class GLSegmentSlideView: UIView {

    /********************************** Propert  ***************************************/
    //MARK:- Property
    
    var delegate : GLSegmentSlideVCDelegate?

    /// 总共的控件数量
    private var numberOfSegment : Int!
    
    /// 存放字符串
    var titleArray : NSArray!
    
    /// 存放每个title字符串的长度
    private var titleWidthArray : [CGFloat]!
    
    /// 存放每个button中心点X的数组
    private var centerXArray : [CGFloat]!
    
    /// 每个button除了字符宽度额外的宽度
    private var extraWidth : CGFloat!
    
    /// 当前选中的下标
    var currentIndex : Int!
    
    /// 底部的滑动条
    var bottomLineView : UIView!
    
    /// 选中title的rgb颜色值
    var selectColorRGBArray : [Int]!
    
    /// 未选中title的rgb颜色值
    var originColorRGBArray : [Int]!
    
    /// 选中的rgb - 未选中的rgb的差值数组
    var subArray : [Int]!
    /******************************** 全局常量 ****************************************/
    /// button的tag值得基数
    let tagOfBaseNumber : Int = 100
    
    /// 字体大小
    let titleSize : CGFloat = 15
    
    /// 原始要的缩放比例
    let originScale : CGFloat = 0.2
    
    /// 原始颜色值
    let originColorHex : NSString = "333333"
    
    let currentColorHex : NSString = "ff4770"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, titleArray : NSArray){
        self.init(frame: frame)
        if titleArray.count <= 0 {
            return;
        }
        self.numberOfSegment = titleArray.count
        self.titleArray = titleArray;
        self.extraWidth = ScreenWidth
        //数组初始化
        self.titleWidthArray = []
        self.centerXArray = []
        self.selectColorRGBArray = []
        self.originColorRGBArray = []
        self.subArray = []
        for title in titleArray {
            var rect : CGRect = title.boundingRectWithSize(CGSizeMake(1000, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(titleSize)], context: nil)
            self.titleWidthArray.append(rect.size.width)
            self.extraWidth = self.extraWidth! - rect.size.width
        }
        self.extraWidth = self.extraWidth! / CGFloat(self.numberOfSegment)
        
        self.setUpSegmentSlideView()
        
        self.reSetButtonScale(0)
        
        self.resetTitleColor()
        
        self.getSubNumber(self.currentColorHex, originHexStr: self.originColorHex)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /********************************** Privite Methods ***************************************/
    //MARK:- Privite Methods
    //MARK: 设置button
    private func setUpSegmentSlideView()
    {
        var buttonX : CGFloat = 0
        for index in 0 ... (numberOfSegment - 1) {
            var tempButton : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            tempButton.setTitle(titleArray[index] as? String, forState: UIControlState.Normal)
            tempButton.titleLabel?.font = UIFont.systemFontOfSize(titleSize)
            tempButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            tempButton.frame = CGRectMake(buttonX, 0, self.titleWidthArray[index] + self.extraWidth, self.frame.size.height)
            tempButton.tag = tagOfBaseNumber + index
            tempButton.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(tempButton)
            buttonX += self.titleWidthArray[index] + self.extraWidth
            
            self.centerXArray.append(tempButton.center.x)
        }
        self.currentIndex = 0
        self.bottomLineView = UIView(frame: CGRectMake(0, self.frame.size.height - 2, self.titleWidthArray[self.currentIndex], 2))
        self.bottomLineView.layer.cornerRadius = 1
        self.bottomLineView.backgroundColor = UIColor.redColor()
        self.bottomLineView.clipsToBounds = true
        self.setBottomLineViewCenter(self.currentIndex)
        self.addSubview(self.bottomLineView)
    }
    
    //MARK: 点击按钮的触发方法
    internal func buttonAction(sender: UIButton)
    {
        self.currentIndex = sender.tag - tagOfBaseNumber
        
        self.delegate?.didSelectSegment(self.currentIndex)
    }
    
    /**
    重置各个button的缩放比例
    */
    private func reSetButtonScale(index: Int)
    {
        for i in 0 ... 2 {
            var tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + i) as! UIButton
            tempButton.transform = index == i ? CGAffineTransformMakeScale( 1.0, 1.0) : CGAffineTransformMakeScale( 1.0 - originScale, 1.0 - originScale)
        }
    }
    
    
    //FIXME: 1.0 因为和updateBottomLineView冲突 会造成动画错位 暂时放弃使用
    //MARK: 设置底部横线的位置 和 宽度
    private func setBottomLineViewCenter(index: Int)
    {
        var tempButton : UIButton = self.viewWithTag(index + tagOfBaseNumber) as! UIButton
        var originRect : CGRect = self.bottomLineView.frame
        originRect.origin.x = tempButton.center.x - (self.titleWidthArray[index])/2.0
        originRect.size.width = self.titleWidthArray[index]
        
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.bottomLineView.frame = originRect
        }, completion: nil)
    }
    
    /**
    设置颜色值
    */
    func resetTitleColor()
    {
        for index in 0 ... 2 {
            var tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + index) as! UIButton
            tempButton.setTitleColor(self.currentIndex == index ? self.getRGBColor(currentColorHex) : self.getRGBColor(originColorHex), forState: UIControlState.Normal)
        }
    }
    
    /**
    返回颜色值 根据传入的十六进制颜色值
    
    - parameter hex: 十六进制字符串  "123456"
    
    - returns: UIColor
    */
    func getRGBColor(hexStr: NSString) -> UIColor {
        var range : NSRange! = NSMakeRange(0, 2)
        range.location = 0
        range.length = 2
        //r
        var rString = hexStr.substringWithRange(range)
        //g
        range.location = 2;
        var gString = hexStr.substringWithRange(range)
        //b
        range.location = 4;
        var bString = hexStr.substringWithRange(range)
        
        // Scan values
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        return UIColor(red: (CGFloat(r) / 255.0), green: (CGFloat(g) / 255.0), blue: (CGFloat(b) / 255.0), alpha: 1)
    }
    
    func getSubNumber(currentHexStr : NSString, originHexStr : NSString) ->(first : Int, second : Int, third : Int) {
        
        var first = 0, second = 0, third = 0
        
        var range : NSRange! = NSMakeRange(0, 2)
        range.location = 0
        range.length = 2
        //r
        var rStringOfCurrent = currentHexStr.substringWithRange(range)
        var rStringOfOrigin = originHexStr.substringWithRange(range)
        //g
        range.location = 2;
        var gStringOfCurrent = currentHexStr.substringWithRange(range)
        var gStringOfOrigin = originHexStr.substringWithRange(range)
        //b
        range.location = 4;
        var bStringOfCurrent = currentHexStr.substringWithRange(range)
        var bStringOfOrigin = originHexStr.substringWithRange(range)
        
        // Scan values
        var rCurrent:CUnsignedInt = 0, gCurrent:CUnsignedInt = 0, bCurrent:CUnsignedInt = 0,
            rOrigin: CUnsignedInt = 0, gOrigin: CUnsignedInt = 0, bOrigin: CUnsignedInt = 0
        
        NSScanner(string: rStringOfCurrent).scanHexInt(&rCurrent)
        NSScanner(string: gStringOfCurrent).scanHexInt(&gCurrent)
        NSScanner(string: bStringOfCurrent).scanHexInt(&bCurrent)
        
        NSScanner(string: rStringOfOrigin).scanHexInt(&rOrigin)
        NSScanner(string: gStringOfOrigin).scanHexInt(&gOrigin)
        NSScanner(string: bStringOfOrigin).scanHexInt(&bOrigin)
        
        first = Int(rCurrent) - Int(rOrigin)
        second = Int(gCurrent) - Int(gOrigin)
        third = Int(bCurrent) - Int(bOrigin)
        
        self.selectColorRGBArray.append(Int(rCurrent))
        self.selectColorRGBArray.append(Int(gCurrent))
        self.selectColorRGBArray.append(Int(bCurrent))
        
        self.originColorRGBArray.append(Int(rOrigin))
        self.originColorRGBArray.append(Int(gOrigin))
        self.originColorRGBArray.append(Int(bOrigin))

        self.subArray.append(first)
        self.subArray.append(second)
        self.subArray.append(third)

        return (first, second, third)
    }
    
    /********************************** Public Methods  ***************************************/
    //MARK:- Public Methods
    //MARK:  实时更新底部按钮 外部滑动时调用
    /**
    设置底部滑动条的位置，根据外部传过来的offset
    
    - parameter offset: 外部的contentOffset
    */
    func updateBottomLineView(offset: CGFloat)
    {

        var index : Int = Int(offset/ScreenWidth)
        self.currentIndex = index
        
        
        //得到进度
        var progress : CGFloat = (offset - ScreenWidth * CGFloat(index)) / ScreenWidth
        
//        if offset/ScreenWidth - CGFloat(index) == 0.0 {
//            self.resetTitleColor()
//        }
        
        var originRect : CGRect = self.bottomLineView.frame
        
        if index >= self.titleArray.count - 1 {
            originRect.size.width = self.titleWidthArray[index]
            originRect.origin.x = self.centerXArray[index] - self.titleWidthArray[index] / 2
            return
        }
        
        if index < 0 {
            return
        }
        
        self.updateButtonFont(progress)
        
        // 从新计算宽度和位置
        originRect.size.width = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) * progress + self.titleWidthArray[index]
        var subRadiusOfButton = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) / 2.0
        originRect.origin.x = abs(self.centerXArray[index] - self.centerXArray[index + 1]) * progress + self.centerXArray[index] - self.titleWidthArray[index] / 2 - subRadiusOfButton * progress

        self.bottomLineView.frame = originRect
    }
    
    /**
    实时更新字体大小根据滑动的进度
    
    - parameter progress: 从一个button到下一个item之间的进度
    */
    func updateButtonFont(progress: CGFloat){
        var currentButton : UIButton = self.viewWithTag(self.currentIndex + tagOfBaseNumber) as! UIButton
        var nextButton : UIButton = self.viewWithTag(self.currentIndex + 1 + tagOfBaseNumber) as! UIButton
        
        currentButton.transform = CGAffineTransformMakeScale(1.0 - originScale * progress, 1.0 - originScale * progress)
        nextButton.transform = CGAffineTransformMakeScale(1.0 + originScale * (progress - 1), 1.0 + originScale * (progress - 1))
        
        var rCurrent = CGFloat(self.selectColorRGBArray[0]) - CGFloat(self.subArray[0]) * progress,
            gCurrent = CGFloat(self.selectColorRGBArray[1]) - CGFloat(self.subArray[1]) * progress,
            bCurrent = CGFloat(self.selectColorRGBArray[2]) - CGFloat(self.subArray[2]) * progress,
            rOrigin = CGFloat(self.originColorRGBArray[0]) + CGFloat(self.subArray[0]) * progress,
            gOrigin = CGFloat(self.originColorRGBArray[1]) + CGFloat(self.subArray[1]) * progress,
            bOrigin = CGFloat(self.originColorRGBArray[2]) + CGFloat(self.subArray[2]) * progress
        
        var currentColor : UIColor = UIColor(red: rCurrent / 255.0, green: gCurrent / 255.0, blue: bCurrent / 255.0, alpha: 1.0)
        var originColor : UIColor = UIColor(red: rOrigin / 255.0, green: gOrigin / 255.0, blue: bOrigin / 255.0, alpha: 1.0)
        currentButton.setTitleColor(currentColor, forState: UIControlState.Normal)
        nextButton.setTitleColor(originColor, forState: UIControlState.Normal)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
