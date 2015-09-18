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
    /******************************** 全局常量 ****************************************/
    /// button的tag值得基数
    let tagOfBaseNumber : Int = 100
    
    /// 字体大小
    let titleSize : CGFloat = 15
    
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
        for title in titleArray {
            var rect : CGRect = title.boundingRectWithSize(CGSizeMake(1000, 20), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(titleSize)], context: nil)
            self.titleWidthArray.append(rect.size.width)
            self.extraWidth = self.extraWidth! - rect.size.width
        }
        self.extraWidth = self.extraWidth! / CGFloat(self.numberOfSegment)
        self.setUpSegmentSlideView()
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
    
    
    /********************************** Public Methods  ***************************************/
    //MARK:- Public Methods
    //MARK:  实时更新底部按钮 外部滑动时调用
    /**
    设置底部滑动条的位置，根据外部传过来的offset

    */
    func updateBottomLineView(offset: CGFloat)
    {

        var index : Int = Int(offset/ScreenWidth)
        self.currentIndex = index
        
        //得到进度
        var progress : CGFloat = (offset - ScreenWidth * CGFloat(index)) / ScreenWidth
        
        var originRect : CGRect = self.bottomLineView.frame
        
        if index >= self.titleArray.count - 1 {
            originRect.size.width = self.titleWidthArray[index]
            originRect.origin.x = self.centerXArray[index] - self.titleWidthArray[index] / 2
            return
        }
        
        if index < 0 {
            return
        }
        // 从新计算宽度和位置
        originRect.size.width = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) * progress + self.titleWidthArray[index]
        var subRadiusOfButton = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) / 2.0
        originRect.origin.x = abs(self.centerXArray[index] - self.centerXArray[index + 1]) * progress + self.centerXArray[index] - self.titleWidthArray[index] / 2 - subRadiusOfButton * progress

        self.bottomLineView.frame = originRect
    }
    

    
}
