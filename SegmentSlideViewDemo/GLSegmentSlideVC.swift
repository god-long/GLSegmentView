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
        
//        return;
//        self.segmentView = GLSegmentSlideView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: 50), titleArray: ["纽约", "思派国际", "攒", "god~long"])
//        self.segmentView?.delegate = self
//        self.segmentView!.backgroundColor = UIColor.white
//        self.view.addSubview(self.segmentView!)

        self.segmentView.loadTitles(titles: ["纽约", "思派国际", "攒", "god~long"])
        self.segmentView.delegate = self
        
        self.contentScrollView!.contentSize = CGSize(width: ScreenWidth * 4, height: 0)

        
        for i in 0 ... 3 {
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
