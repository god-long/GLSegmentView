//
//  SegmentSlideVC.swift
//  LongPratice
//
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit



class GLSegmentSlideVC: UIViewController, UIScrollViewDelegate, GLSegmentSlideVCDelegate {

    /********************************** Propert  ***************************************/
    //MARK:- Property·
    
    /// 分类滑动View
    var segmentView : GLSegmentSlideView?
    
    /// 内容scrollView
    var contentScrollView : UIScrollView?

    
    /********************************** System Methods ***************************************/
    //MARK:- System Methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        self.title = "SegmentSlideDemo"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.segmentView = GLSegmentSlideView(frame: CGRectMake(0, 64, ScreenWidth, 50), titleArray: ["美甲天下","美","秀美甲大咖"])
        self.segmentView?.delegate = self
        self.segmentView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.segmentView!)

        
        self.contentScrollView = UIScrollView(frame: CGRectMake(0, CGRectGetMinY(segmentView!.frame) + CGRectGetHeight(segmentView!.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(segmentView!.frame)))
        self.contentScrollView!.backgroundColor = UIColor.grayColor()
        self.contentScrollView!.pagingEnabled = true
        self.contentScrollView!.bounces = false
        self.contentScrollView!.contentSize = CGSizeMake(ScreenWidth * 3, 0)
        self.contentScrollView!.delegate = self;
        self.view.addSubview(self.contentScrollView!)
        
        for var i = 0; i < 3; i++ {
            var tempLabel : UILabel = UILabel(frame: CGRectMake(0, 0, 60, 50))
            tempLabel.center = CGPointMake((ScreenWidth/2.0) + ScreenWidth * CGFloat(i), (CGRectGetHeight(self.contentScrollView!.frame))/2.0)
            tempLabel.backgroundColor = UIColor.whiteColor()
            tempLabel.textAlignment = NSTextAlignment.Center
            tempLabel.text = "第" + String(i) + "页"
            tempLabel.font = UIFont.systemFontOfSize(14)
            tempLabel.textColor = UIColor.redColor()
            self.contentScrollView!.addSubview(tempLabel)
        }
        
    }

    
    /********************************** Privite Methods ***************************************/
    //MARK:- Privite Methods
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.segmentView?.updateBottomLineView(scrollView.contentOffset.x)
    }
    
    //MARK: SegmentSlideViewDelegate
    func didSelectSegment(index: Int) {
        self.contentScrollView!.setContentOffset(CGPointMake(CGFloat(index) * ScreenWidth, 0), animated: true)
    }

    

    
    
    /********************************** MemoryWarn *****************************************/
    //MARK:- MemoryWarn
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
