# GLSegmentView(标题分类控件)
 
 ![](https://img.shields.io/badge/Swift-3.0-orange.svg) [![GitHub tag](https://img.shields.io/github/tag/god-long/GLSegmentView.svg)](https://github.com/god-long/GLSegmentView/tags) [![license](https://img.shields.io/github/license/god-long/GLSegmentView.svg)](https://github.com/god-long/GLSegmentView/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/god-long/GLSegmentView.svg?style=social&label=Star)](https://github.com/god-long/GLSegmentView) [![GitHub forks](https://img.shields.io/github/forks/god-long/GLSegmentView.svg?style=social&label=Fork)]()

## 描述:

   **该控件一般和UIScrollView一起使用，点击控件通过代理回调给UIScrollView来
    改变ContentOffset来达到控制页数的效果**

## 功能:

  * 可根据滑动的距离来实时更新底部线条的位置和宽度;
  * 宽度是根据每个分割的控件`title`的宽度而定;
  * 根据滑动距离实时颜色渐变;
  * 支持**code**，**xib**，**storyboard**;
  * 支持旋转;
 
 
## 展示图

### iPhone

 ![](https://github.com/god-long/GLSegmentSlideView/raw/master/GLSegmentView-iPhone.gif)

### iPad

 ![](https://github.com/god-long/GLSegmentSlideView/raw/master/GLSegmentView-iPad.gif)

## 安装：

### [CocoaPods](https://cocoapods.org/)

```
pod 'GLSegmentView'
```

因为使用了xib文件，支持在storyboard和xib中使用该控件，导致在使用时，storyboard和xib找不到该控件的module。
当前如果通过pod安装，并且在storyboard或者xib中使用的话，需要手动更改如图：(会有编译报错，运行没问题，待解决)

 ![](https://github.com/god-long/GLSegmentSlideView/raw/master/pod-use.png)


### 手动（当前鼓励的方式）

下载文件，添加GLSegmentView.swift和GLSegmentView.xib到工程文件中即可。

## 使用:

**如果是iPhone需要支持旋转，必须添加如下代码**

```
    // MARK: 如果是iPhone需要屏幕旋转功能，必须添加此方法
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.segmentView.beforeLayoutIndex = self.segmentView.currentSelectIndex
    }

```


### xib or storyboard:

```
        let titles =  ["路飞", "Medbanks", "One", "Piece", "god~long"]

        self.segmentView.titleArray = titles
        self.segmentView.delegate = self
        

    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.segmentView.updateSegmentView(scrollView.contentOffset.x, pageWidth: scrollView.frame.width)
    }

    //MARK: SegmentSlideViewDelegate
    func didSelectSegment(_ index: Int) {
        // animated必须为false，如果想点击segment的时候也动画滑动，必须添加额外的参数控制
        self.contentScrollView!.setContentOffset(CGPoint(x: CGFloat(index) * ScreenWidth, y: 0), animated: false)
    }

```

### code:

```
         // 代码创建 需要去掉属性的IBOutlet
        self.segmentView = GLSegmentView(frame: CGRect(x: 0, y: 0, width: self.contentScrollView.frame.width, height: 50))
        self.segmentView.titleArray = titles
        self.segmentView?.delegate = self
        self.view.addSubview(self.segmentView!)


```



 

 **如有意见，欢迎issue**
