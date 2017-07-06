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
    func didSelectSegment(_ index : Int)
}


@IBDesignable class GLSegmentSlideView: UIView {

    /********************************** Propert  ***************************************/
    //MARK:- Public Property
    
    public var delegate : GLSegmentSlideVCDelegate?

    /// 存放字符串
    public var titleArray: [String]!
    
    
    //MARK:- Private Property
    
    /// 存放每个title字符串的长度
    private var titleWidthArray : [CGFloat]!
    
    /// 存放每个button中心点X的数组
    fileprivate var centerXArray : [CGFloat]!
    
    /// 每个button除了字符宽度额外的宽度
    fileprivate var extraWidth : CGFloat!
    
    /// 总共的控件数量
    public var numberOfSegment : Int!
    
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
    //MARK:- 全局常量
    /// button的tag值得基数
    let tagOfBaseNumber : Int = 100
    
    /// 字体大小
    let titleSize : CGFloat = 15
    
    /// 原始要的缩放比例
    let originScale : CGFloat = 0.2
    
    /// 原始颜色值
    @IBInspectable var originColorHex : NSString = "333333" {
        didSet {
            
        }
    }
    
    ///
    @IBInspectable var currentColorHex : NSString = "ff4770" {
        didSet {
            
        }
    }
    
    /// 加载View
    var contentView: UIView!
    
    /****************************** Init Methods *****************************/
    
    //MARK:- Init Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // why: https://stackoverflow.com/questions/35700191/failed-to-render-instance-of-classname-the-agent-threw-an-exception-loading-nib
        let bundle = Bundle(for: GLSegmentSlideView.self)
        let nib = UINib(nibName: String(describing: GLSegmentSlideView.self), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //然后可以在添加东西在contentVie上或者配置其它
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: GLSegmentSlideView.self)
        let nib = UINib(nibName: String(describing: GLSegmentSlideView.self), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //然后可以在添加东西在contentVie上或者配置其它
        self.commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(frame: CGRect, titles : [String]){
        self.init(frame: frame)
        if titles.count <= 0 {
            return;
        }
        self.numberOfSegment = titles.count
        self.titleArray = titles;
        self.extraWidth = ScreenWidth
        //数组初始化
        self.titleWidthArray = []
        self.centerXArray = []
        self.selectColorRGBArray = []
        self.originColorRGBArray = []
        self.subArray = []
        for title in titles {
            let rect : CGRect = (title as AnyObject).boundingRect(with: CGSize(width: 1000, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: titleSize)], context: nil)
            self.titleWidthArray.append(rect.size.width)
            self.extraWidth = self.extraWidth! - rect.size.width
        }
        self.extraWidth = self.extraWidth! / CGFloat(self.numberOfSegment)
        
        self.setUpSegmentSlideView()
        
        self.resetButtonScale(0)
        
        self.resetTitleColor()
        
        self.getSubNumber(self.currentColorHex, originHexStr: self.originColorHex)

    }
    
    private func commonInit() {
        self.extraWidth = ScreenWidth
        //数组初始化
        self.titleWidthArray = []
        self.centerXArray = []
        self.selectColorRGBArray = []
        self.originColorRGBArray = []
        self.subArray = []
        self.getSubNumber(self.currentColorHex, originHexStr: self.originColorHex)
    }
    
    /// 重新装载
    public func loadTitles(titles: [String]) {

        if titles.count <= 0 {
            return;
        }
        self.numberOfSegment = titles.count
        self.titleArray = titles;
        self.extraWidth = ScreenWidth

        self.titleWidthArray.removeAll()
        self.centerXArray.removeAll()
        
        for title in titles {
            let rect : CGRect = (title as AnyObject).boundingRect(with: CGSize(width: 1000, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: titleSize)], context: nil)
            self.titleWidthArray.append(rect.size.width)
            self.extraWidth = self.extraWidth! - rect.size.width
        }
        self.extraWidth = self.extraWidth! / CGFloat(self.numberOfSegment)
        
        for aView in self.contentView.subviews {
            aView.removeFromSuperview()
        }
        self.setUpSegmentSlideView()
        
        self.resetButtonScale(0)
        
        self.resetTitleColor()
        
//        self.getSubNumber(self.currentColorHex, originHexStr: self.originColorHex)
    }

    
    /******************************** Privite Methods *********************************/
    //MARK:- Privite Methods
    //MARK: 设置button 和 bottomLine
    fileprivate func setUpSegmentSlideView() {
        
        var buttonX : CGFloat = 0
        for index in 0 ... (numberOfSegment - 1) {
            let tempButton : UIButton = UIButton(type: .custom)
            tempButton.setTitle(titleArray[index], for: UIControlState())
            tempButton.titleLabel?.font = UIFont.systemFont(ofSize: titleSize)
            tempButton.setTitleColor(UIColor.black, for: UIControlState())
            tempButton.frame = CGRect(x: buttonX, y: 0, width: self.titleWidthArray[index] + self.extraWidth, height: self.frame.size.height)
            tempButton.tag = tagOfBaseNumber + index
            tempButton.addTarget(self, action: #selector(GLSegmentSlideView.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            self.contentView.addSubview(tempButton)
            buttonX += self.titleWidthArray[index] + self.extraWidth
            
            self.centerXArray.append(tempButton.center.x)
        }
        self.currentIndex = 0
        self.bottomLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 2, width: self.titleWidthArray[self.currentIndex], height: 2))
        self.bottomLineView.layer.cornerRadius = 1
        self.bottomLineView.backgroundColor = UIColor.red
        self.bottomLineView.clipsToBounds = true
        self.setBottomLineViewCenter(self.currentIndex)
        self.contentView.addSubview(self.bottomLineView)
    }
    
    //MARK: 点击按钮的触发方法
    internal func buttonAction(_ sender: UIButton) {
        self.currentIndex = sender.tag - tagOfBaseNumber
        self.delegate?.didSelectSegment(self.currentIndex)
    }
    
    /**
    重置各个button的缩放比例
    */
    fileprivate func resetButtonScale(_ index: Int) {
        for i in 0 ... self.numberOfSegment - 1 {
            let tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + i) as! UIButton
            tempButton.transform = index == i ? CGAffineTransform( scaleX: 1.0, y: 1.0) : CGAffineTransform( scaleX: 1.0 - originScale, y: 1.0 - originScale)
        }
    }
    
    
    //FIXME: 1.0 因为和updateBottomLineView冲突 会造成动画错位 暂时放弃使用
    //MARK: 设置底部横线的位置 和 宽度
    fileprivate func setBottomLineViewCenter(_ index: Int) {
        let tempButton : UIButton = self.viewWithTag(index + tagOfBaseNumber) as! UIButton
        var originRect : CGRect = self.bottomLineView.frame
        originRect.origin.x = tempButton.center.x - (self.titleWidthArray[index])/2.0
        originRect.size.width = self.titleWidthArray[index]
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.bottomLineView.frame = originRect
        }, completion: nil)
    }
    
    /**
    设置颜色值
    */
    func resetTitleColor() {
        for index in 0 ... self.numberOfSegment - 1 {
            let tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + index) as! UIButton
            tempButton.setTitleColor(self.currentIndex == index ? self.getRGBColor(currentColorHex) : self.getRGBColor(originColorHex), for: UIControlState())
        }
    }
    
    /**
    返回颜色值 根据传入的十六进制颜色值
    
    - parameter hex: 十六进制字符串  "123456"
    
    - returns: UIColor
    */
    func getRGBColor(_ hexStr: NSString) -> UIColor {
        var range : NSRange! = NSMakeRange(0, 2)
        range.location = 0
        range.length = 2
        //r
        let rString = hexStr.substring(with: range)
        //g
        range.location = 2;
        let gString = hexStr.substring(with: range)
        //b
        range.location = 4;
        let bString = hexStr.substring(with: range)
        
        // Scan values
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: (CGFloat(r) / 255.0), green: (CGFloat(g) / 255.0), blue: (CGFloat(b) / 255.0), alpha: 1)
    }
    
    @discardableResult
    func getSubNumber(_ currentHexStr : NSString, originHexStr : NSString) ->(first : Int, second : Int, third : Int) {
        
        var first = 0, second = 0, third = 0
        
        var range : NSRange! = NSMakeRange(0, 2)
        range.location = 0
        range.length = 2
        //r
        let rStringOfCurrent = currentHexStr.substring(with: range)
        let rStringOfOrigin = originHexStr.substring(with: range)
        //g
        range.location = 2;
        let gStringOfCurrent = currentHexStr.substring(with: range)
        let gStringOfOrigin = originHexStr.substring(with: range)
        //b
        range.location = 4;
        let bStringOfCurrent = currentHexStr.substring(with: range)
        let bStringOfOrigin = originHexStr.substring(with: range)
        
        // Scan values
        var rCurrent:CUnsignedInt = 0, gCurrent:CUnsignedInt = 0, bCurrent:CUnsignedInt = 0,
            rOrigin: CUnsignedInt = 0, gOrigin: CUnsignedInt = 0, bOrigin: CUnsignedInt = 0
        
        Scanner(string: rStringOfCurrent).scanHexInt32(&rCurrent)
        Scanner(string: gStringOfCurrent).scanHexInt32(&gCurrent)
        Scanner(string: bStringOfCurrent).scanHexInt32(&bCurrent)
        
        Scanner(string: rStringOfOrigin).scanHexInt32(&rOrigin)
        Scanner(string: gStringOfOrigin).scanHexInt32(&gOrigin)
        Scanner(string: bStringOfOrigin).scanHexInt32(&bOrigin)
        
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
    
    /******************************* Public Methods  ************************************/
    //MARK:- Public Methods
    //MARK:  实时更新底部按钮 外部滑动时调用
    /**
    设置底部滑动条的位置，根据外部传过来的offset
    
    - parameter offset: 外部的contentOffset
    */
    public func updateBottomLineView(_ offset: CGFloat) {

        let index : Int = Int(offset/ScreenWidth)
        self.currentIndex = index
        
        
        //得到进度
        let progress : CGFloat = (offset - ScreenWidth * CGFloat(index)) / ScreenWidth
        
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
        let subRadiusOfButton = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) / 2.0
        originRect.origin.x = abs(self.centerXArray[index] - self.centerXArray[index + 1]) * progress + self.centerXArray[index] - self.titleWidthArray[index] / 2 - subRadiusOfButton * progress

        self.bottomLineView.frame = originRect
    }
    
    /**
    实时更新字体大小根据滑动的进度
    
    - parameter progress: 从一个button到下一个item之间的进度
    */
    private func updateButtonFont(_ progress: CGFloat) {
        let currentButton : UIButton = self.viewWithTag(self.currentIndex + tagOfBaseNumber) as! UIButton
        let nextButton : UIButton = self.viewWithTag(self.currentIndex + 1 + tagOfBaseNumber) as! UIButton
        
        currentButton.transform = CGAffineTransform(scaleX: 1.0 - originScale * progress, y: 1.0 - originScale * progress)
        nextButton.transform = CGAffineTransform(scaleX: 1.0 + originScale * (progress - 1), y: 1.0 + originScale * (progress - 1))
        
        let rCurrent = CGFloat(self.selectColorRGBArray[0]) - CGFloat(self.subArray[0]) * progress,
            gCurrent = CGFloat(self.selectColorRGBArray[1]) - CGFloat(self.subArray[1]) * progress,
            bCurrent = CGFloat(self.selectColorRGBArray[2]) - CGFloat(self.subArray[2]) * progress,
            rOrigin = CGFloat(self.originColorRGBArray[0]) + CGFloat(self.subArray[0]) * progress,
            gOrigin = CGFloat(self.originColorRGBArray[1]) + CGFloat(self.subArray[1]) * progress,
            bOrigin = CGFloat(self.originColorRGBArray[2]) + CGFloat(self.subArray[2]) * progress
        
        let currentColor : UIColor = UIColor(red: rCurrent / 255.0, green: gCurrent / 255.0, blue: bCurrent / 255.0, alpha: 1.0)
        let originColor : UIColor = UIColor(red: rOrigin / 255.0, green: gOrigin / 255.0, blue: bOrigin / 255.0, alpha: 1.0)
        currentButton.setTitleColor(currentColor, for: UIControlState())
        nextButton.setTitleColor(originColor, for: UIControlState())
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
