//
//  SegmentSlideView.swift
//  LongPratice
//  https://github.com/god-long/GLSegmentView
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

public protocol GLSegmentViewDelegate {
    /**
    点击某个控件代理执行的方法
    
    - parameter index: 点击控件的下标
    */
    func didSelectSegment(_ index : Int)
}



@IBDesignable open class GLSegmentView: UIView {

    /********************** Propert  **********************/
    //MARK:- Public Property
    
    public var delegate: GLSegmentViewDelegate?
    
//    public weak var scrollView: UIScrollView!
    
    /// 存放字符串
    public var titleArray: [String]! = [] {
        didSet {
            self.loadTitles(titles: titleArray)
        }
    }
    

    /// 字体大小
    @IBInspectable public var titleFontSize: CGFloat = 15 {
        didSet {
            if self.titleArray.count > 0 {
                for tempButton in self.buttonArray {
                    tempButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
                }
            }
        }
    }
    
    /// 原始的缩放比例差值
    @IBInspectable public var originScale: CGFloat = 0.2 {
        didSet {
            
        }
    }
    
    /// 原始颜色值
    @IBInspectable public var normalColor: UIColor = .darkText {
        didSet {
            
        }
    }
    
    /// 选中颜色值
    @IBInspectable public var selectColor: UIColor = .orange {
        didSet {
            
        }
    }
    
    @IBInspectable public var bottomLineColor: UIColor = .red {
        didSet {
            self.bottomLineView.backgroundColor = self.bottomLineColor
        }
    }
    
    /// 将要旋转之前的currentIndex记录
    public var beforeLayoutIndex: Int = 0
    
    public var currentSelectIndex: Int {
        get {
            return self.currentIndex
        }
    }
    
    //MARK:- Private Property
    
    /// 存放每个title字符串的长度
    fileprivate var titleWidthArray : [CGFloat]!
    
    /// 存放每个button中心点X的数组
    fileprivate var centerXArray : [CGFloat]!
    
    /// 每个button除了字符宽度额外的宽度
    fileprivate var extraWidth : CGFloat!
    
    /// 当前选中的下标
    fileprivate var currentIndex : Int!
    
    /// 底部的滑动条
    fileprivate var bottomLineView : UIView!
    
    /// 选中title的rgb颜色值
    fileprivate var selectColorRGBArray : [Int]!
    
    /// 未选中title的rgb颜色值
    fileprivate var normalColorRGBArray : [Int]!
    
    /// 选中的rgb - 未选中的rgb的差值数组
    fileprivate var subArray : [Int]!
    
    /// button的tag值得基数
    fileprivate let tagOfBaseNumber : Int = 100

    /// 存放button的数组
    fileprivate var buttonArray: [UIButton]!
    
    /// 加载View
    private var contentView: UIView!
    
    /************************ Init Methods *************************/
    //MARK:- Init Methods
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // why: https://stackoverflow.com/questions/35700191/failed-to-render-instance-of-classname-the-agent-threw-an-exception-loading-nib
        let bundle = Bundle(for: GLSegmentView.self)
        let nib = UINib(nibName: String(describing: GLSegmentView.self), bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.addSubview(contentView)
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //然后可以在添加东西在contentVie上或者配置其它
        self.commonInit()
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let bundlePath = Bundle(for: GLSegmentView.self).path(forResource: "GLSegmentView", ofType: "bundle")

        assert(bundlePath == nil, "bundlePath is nil")

        
        let segmentBundle = Bundle(path: bundlePath!)
        let nib = UINib(nibName: String(describing: GLSegmentView.self), bundle: segmentBundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.addSubview(contentView)
        self.contentView.frame = bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //然后可以在添加东西在contentVie上或者配置其它
        self.commonInit()
    }
            
    private func commonInit() {
        self.extraWidth = self.frame.width
        //数组初始化
        self.buttonArray = []
        self.titleWidthArray = []
        self.centerXArray = []
        self.selectColorRGBArray = []
        self.normalColorRGBArray = []
        self.subArray = []
        self.configColorArray()
        self.currentIndex = 0
        self.beforeLayoutIndex = self.currentIndex
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    /************************** Privite Methods ***************************/
    //MARK:- Privite Methods
    
    //MARK: 设置button 和 bottomLine
    fileprivate func setUpSegmentSlideView() {
        self.buttonArray.removeAll()
        self.centerXArray.removeAll()

        var buttonX : CGFloat = 0
        for index in 0 ... (self.titleArray.count - 1) {
            let tempButton : UIButton = UIButton(type: .custom)
            tempButton.setTitle(self.titleArray[index], for: UIControlState())
            tempButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
            tempButton.setTitleColor(UIColor.black, for: UIControlState())
            tempButton.frame = CGRect(x: buttonX, y: 0, width: self.titleWidthArray[index] + self.extraWidth, height: self.frame.size.height)
            tempButton.tag = tagOfBaseNumber + index
            tempButton.addTarget(self, action: #selector(self.itemAction(_:)), for: .touchUpInside)
            self.buttonArray.append(tempButton)
            self.contentView.addSubview(tempButton)
            buttonX += self.titleWidthArray[index] + self.extraWidth
            
            self.centerXArray.append(tempButton.center.x)
        }
        
        if self.bottomLineView == nil {
            self.bottomLineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 2, width: self.titleWidthArray[self.currentIndex], height: 2))
        }else {
            self.bottomLineView.frame =  CGRect(x: 0, y: self.frame.size.height - 2, width: self.titleWidthArray[self.currentIndex], height: 2)
        }
        self.bottomLineView.layer.cornerRadius = 1
        self.bottomLineView.backgroundColor = UIColor.red
        self.bottomLineView.clipsToBounds = true
        let tempButton = self.buttonArray[self.currentIndex]
        var originRect = self.bottomLineView.frame
        originRect.origin.x = tempButton.center.x - (self.titleWidthArray[self.currentIndex]) / 2.0
        originRect.size.width = self.titleWidthArray[self.currentIndex]
        self.bottomLineView.frame = originRect
        self.contentView.addSubview(self.bottomLineView)
    }
    
    
    /// 重置各个button的缩放比例
    fileprivate func resetButtonScale() {
        for i in 0 ... self.titleArray.count - 1 {
            let tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + i) as! UIButton
            tempButton.transform = self.currentIndex == i ? CGAffineTransform(scaleX: 1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0 - originScale, y: 1.0 - originScale)
        }
    }
    
    
    /// 设置颜色值
    fileprivate func resetTitleColor() {
        for index in 0 ... self.titleArray.count - 1 {
            let tempButton : UIButton = self.viewWithTag(tagOfBaseNumber + index) as! UIButton
            tempButton.setTitleColor(self.currentIndex == index ? self.selectColor : self.normalColor, for: UIControlState())
        }
    }
    
    /// 配置选中的RGB数组、正常的RGB数组、差值RGB数组
    fileprivate func configColorArray() {
        
        var normalR: Float = 0.0, normalG: Float = 0.0, normalB: Float = 0.0,
        selectR: Float = 0.0 , selectG: Float = 0.0, selectB: Float = 0.0
        
        let normalCGColor = self.normalColor.cgColor
        let normalNumComponents = normalCGColor.numberOfComponents;
        if normalNumComponents == 4 {
            let normalComponnents = normalCGColor.components
            normalR = Float(normalComponnents![0]);
            normalG = Float(normalComponnents![1]);
            normalB = Float(normalComponnents![2]);
        }
        
        let selectCGColor = self.selectColor.cgColor
        let selectNumComponents = selectCGColor.numberOfComponents;
        if selectNumComponents == 4 {
            let selectComponnents = selectCGColor.components
            selectR = Float(selectComponnents![0]);
            selectG = Float(selectComponnents![1]);
            selectB = Float(selectComponnents![2]);
        }

        
        let first = Int((selectR - normalR) * 255.0)
        let second = Int((selectG - normalG) * 255.0)
        let third = Int((selectB - normalB) * 255.0)
        
        self.selectColorRGBArray.append(Int(selectR * 255.0))
        self.selectColorRGBArray.append(Int(selectG * 255.0))
        self.selectColorRGBArray.append(Int(selectB * 255.0))
        
        self.normalColorRGBArray.append(Int(normalR * 255.0))
        self.normalColorRGBArray.append(Int(normalG * 255.0))
        self.normalColorRGBArray.append(Int(normalB * 255.0))

        self.subArray.append(first)
        self.subArray.append(second)
        self.subArray.append(third)
    }
    
    //MARK: 点击按钮的触发方法
    @objc private func itemAction(_ button: UIButton) {
        let toIndex = button.tag - tagOfBaseNumber
        self.updateBottomLineAndItem(toItemIndex: toIndex, animated: true)
        self.currentIndex = toIndex
        self.delegate?.didSelectSegment(self.currentIndex)
    }
    
    /// 点击更改bottomLine指示条和button颜色、大小
    /// 外界ScrollView滑动动画大约是0.3S
    /// - Parameter toIndex: 点击的item下标
    fileprivate func updateBottomLineAndItem(toItemIndex toIndex: Int, animated: Bool) {
        
        // 底部View
        var originRect: CGRect = self.bottomLineView.frame
        originRect.size.width = self.titleWidthArray[toIndex]
        originRect.origin.x = self.centerXArray[toIndex] - self.titleWidthArray[toIndex] / 2.0
        
        //颜色和大小
        let currentButton = self.buttonArray[self.currentIndex]
        let toButton = self.buttonArray[toIndex]
        
        currentButton.setTitleColor(self.normalColor, for: UIControlState())
        toButton.setTitleColor(self.selectColor, for: UIControlState())
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.bottomLineView.frame = originRect
                currentButton.transform = CGAffineTransform(scaleX: 1.0 - self.originScale, y: 1.0 - self.originScale)
                toButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { finish in
            }
        }else {
            self.bottomLineView.frame = originRect
            currentButton.transform = CGAffineTransform(scaleX: 1.0 - self.originScale, y: 1.0 - self.originScale)
            toButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// 实时更新字体大小根据滑动的进度，此方法适用于用户滑动，不适用于点击item更换位置
    ///
    /// - Parameter progress: 从一个item到下一个item之间的进度
    fileprivate func updateButtonFont(_ progress: CGFloat) {
        let currentButton = self.buttonArray[self.currentIndex]
        let nextButton = self.buttonArray[self.currentIndex + 1]
        
        currentButton.transform = CGAffineTransform(scaleX: 1.0 - originScale * progress, y: 1.0 - originScale * progress)
        nextButton.transform = CGAffineTransform(scaleX: 1.0 + originScale * (progress - 1), y: 1.0 + originScale * (progress - 1))
        
        let rSelect = CGFloat(self.selectColorRGBArray[0]) - CGFloat(self.subArray[0]) * progress,
        gSelect = CGFloat(self.selectColorRGBArray[1]) - CGFloat(self.subArray[1]) * progress,
        bSelect = CGFloat(self.selectColorRGBArray[2]) - CGFloat(self.subArray[2]) * progress,
        rNormal = CGFloat(self.normalColorRGBArray[0]) + CGFloat(self.subArray[0]) * progress,
        gNormal = CGFloat(self.normalColorRGBArray[1]) + CGFloat(self.subArray[1]) * progress,
        bNormal = CGFloat(self.normalColorRGBArray[2]) + CGFloat(self.subArray[2]) * progress
        
        let currentColor: UIColor = UIColor(red: rSelect / 255.0, green: gSelect / 255.0, blue: bSelect / 255.0, alpha: 1.0)
        let originColor: UIColor = UIColor(red: rNormal / 255.0, green: gNormal / 255.0, blue: bNormal / 255.0, alpha: 1.0)
        currentButton.setTitleColor(currentColor, for: UIControlState())
        nextButton.setTitleColor(originColor, for: UIControlState())
    }


    /// 重新装载
    ///
    /// - Parameter titles: 数据源
    fileprivate func loadTitles(titles: [String]) {
        
        if titles.count <= 0 {
            return;
        }
        
        self.extraWidth = self.contentView.frame.width
        
        self.titleWidthArray.removeAll()
        
        for title in titles {
            let rect : CGRect = (title as AnyObject).boundingRect(with: CGSize(width: 1000, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: titleFontSize)], context: nil)
            self.titleWidthArray.append(rect.size.width)
            self.extraWidth = self.extraWidth! - rect.size.width
        }
        self.extraWidth = self.extraWidth! / CGFloat(self.titleArray.count)
        
        for aView in self.contentView.subviews {
            aView.removeFromSuperview()
        }
        self.setUpSegmentSlideView()
        
        self.resetButtonScale()
        
        self.resetTitleColor()
    }
    
    /******************************* Public Methods  ************************************/
    //MARK:- Public Methods
    
    //MARK:  实时更新底部按钮 外部滑动时调用
    /// 设置底部滑动条的位置，根据外部传过来的offset，当用户点击item来更换显示内容的时候，此方法不再适用
    /// 如果当前是第一个，用户点击最后一个（多于3个）时，外界监听的contentOffset（不管以何种方式监听的contentOffset）都不是连续的
    /// 这就会导致中间的item根据offset实时改变大小和颜色出现误差。不连续是因为应用程序正在接收的触发速度比屏幕刷新率快。
    ///
    /// - Parameters:
    ///   - offset: 外部的contentOffset
    ///   - pageWidth: 外部滑动的控件一页的宽度
    public func updateSegmentView(_ offset: CGFloat, pageWidth: CGFloat) {

        let index: Int = Int(floor(offset/pageWidth))
        self.currentIndex = index
        
        
        //得到进度
        let progress: CGFloat = (offset - pageWidth * CGFloat(index)) / pageWidth
        
        var originRect: CGRect = self.bottomLineView.frame
        
        if index < 0 || index >= self.titleArray.count - 1 {
            return
        }
        
        self.updateButtonFont(progress)
        
        // 重新计算宽度和位置
        originRect.size.width = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) * progress + self.titleWidthArray[index]
        let subRadiusOfButton = (self.titleWidthArray[index + 1] - self.titleWidthArray[index]) / 2.0
        originRect.origin.x = abs(self.centerXArray[index] - self.centerXArray[index + 1]) * progress + self.centerXArray[index] - self.titleWidthArray[index] / 2 - subRadiusOfButton * progress

        self.bottomLineView.frame = originRect
    }
    
    
    //MARK: 屏幕旋转监听 在layoutSubviews之前 把下标记录
    func handleDeviceOrientationDidChange() {
        self.beforeLayoutIndex = self.currentIndex
    }


    override open func layoutSubviews() {
        super.layoutSubviews()
        self.loadTitles(titles: self.titleArray)
        self.updateBottomLineAndItem(toItemIndex: self.beforeLayoutIndex, animated: false)
        self.currentIndex = self.beforeLayoutIndex
        self.delegate?.didSelectSegment(self.beforeLayoutIndex)
    }
    
}
