//
//  SegmentSlideVC.swift
//  LongPratice
//
//  Created by god、long on 15/9/16.
//  Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

class GLSegmentSlideVC: UIViewController, UIScrollViewDelegate, GLSegmentSlideVCDelegate {

    /******************************* Propert ************************************/
    //MARK:- Property
    
    /// 分类滑动View
    @IBOutlet weak var segmentView : GLSegmentSlideView!
    
    /// 内容scrollView
    @IBOutlet weak var contentScrollView : UIScrollView!

    
    /****************************** System Methods ***********************************/
    //MARK:- System Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.title = "SegmentSlideDemo"
        
        self.edgesForExtendedLayout = [.left, .bottom, .right]
        self.automaticallyAdjustsScrollViewInsets = false
        
        let titles =  ["路飞", "Medbanks", "One", "Piece", "god~long"]

        /* 
         // 代码创建 需要去掉属性的IBOutlet
        self.segmentView = GLSegmentSlideView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50), titles: titles)
        self.segmentView?.delegate = self
        self.view.addSubview(self.segmentView!)
         */

        self.segmentView.loadTitles(titles: titles)
        self.segmentView.delegate = self

        
        self.contentScrollView!.contentSize = CGSize(width: ScreenWidth * CGFloat(titles.count), height: 0)

        
        for i in 0 ..< titles.count {
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
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm:ss.SSS"
        print(formatter.string(from: Date()), terminator: "  ")
        print(scrollView.contentOffset.x)
        
        self.segmentView.updateBottomLineView(scrollView.contentOffset.x)
    }
    
    //MARK: SegmentSlideViewDelegate
    func didSelectSegment(_ index: Int) {
        // animated必须为false，如果想点击segment的时候也动画滑动，必须添加额外的参数控制
        self.contentScrollView!.setContentOffset(CGPoint(x: CGFloat(index) * ScreenWidth, y: 0), animated: false)
    }

    

    
    /************************ MemoryWarn *******************************/
    //MARK:- MemoryWarn
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
