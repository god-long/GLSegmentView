//
//  SegmentSlideVC.swift
//  LongPratice
//
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit



class GLSegmentSlideVC: UIViewController, UIScrollViewDelegate, GLSegmentSlideVCDelegate {

    /******************************* Propert  ************************************/
    //MARK:- Property
    
    /// 分类滑动View
    var segmentView : GLSegmentSlideView?
    
    /// 内容scrollView
    var contentScrollView : UIScrollView?

    
    /****************************** System Methods ***********************************/
    //MARK:- System Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.title = "SegmentSlideDemo"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.segmentView = GLSegmentSlideView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: 50), titleArray: ["纽约","思派国际","攒"])
        self.segmentView?.delegate = self
        self.segmentView!.backgroundColor = UIColor.white
        self.view.addSubview(self.segmentView!)

        
        self.contentScrollView = UIScrollView(frame: CGRect(x: 0, y: self.segmentView!.frame.minY + segmentView!.frame.height, width: ScreenWidth, height: ScreenHeight - self.segmentView!.frame.maxY))
        self.contentScrollView!.backgroundColor = UIColor.orange
        self.contentScrollView!.isPagingEnabled = true
        self.contentScrollView!.bounces = false
        self.contentScrollView!.contentSize = CGSize(width: ScreenWidth * 3, height: 0)
        self.contentScrollView!.delegate = self;
        self.view.addSubview(self.contentScrollView!)
        
        for i in 0 ..< 3 {
            let tempLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            tempLabel.center = CGPoint(x: (ScreenWidth/2.0) + ScreenWidth * CGFloat(i), y: (self.contentScrollView!.frame.height)/2.0)
            tempLabel.backgroundColor = UIColor.white
            tempLabel.textAlignment = NSTextAlignment.center
            tempLabel.text = "第" + String(i) + "页"
            tempLabel.font = UIFont.systemFont(ofSize: 14)
            tempLabel.textColor = UIColor.red
            self.contentScrollView!.addSubview(tempLabel)
        }
        
    }

    
    /******************** Privite Methods ****************************/
    //MARK:- Privite Methods
    
    
    
    //MARK: - Delegate
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.segmentView?.updateBottomLineView(scrollView.contentOffset.x)
    }
    
    //MARK: SegmentSlideViewDelegate
    func didSelectSegment(_ index: Int) {
        self.contentScrollView!.setContentOffset(CGPoint(x: CGFloat(index) * ScreenWidth, y: 0), animated: true)
    }

    

    
    /************************ MemoryWarn *******************************/
    //MARK:- MemoryWarn
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
