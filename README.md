# GLSegmentView

## 标题分类控件

#### 描述:

   **该控件一般和UIScrollView一起使用，点击控件通过代理回调给UIScrollView来
    改变ContentOffset来达到控制页数的效果**

#### 功能:

  * 可根据滑动的距离来实时更新底部线条的位置和宽度;
  * 宽度是根据每个分割的控件title的宽度而定;
  * 根据滑动距离使颜色渐变;
  * 支持code，xib，storyboard;
 
 
#### 展示图

 ![](https://github.com/god-long/GLSegmentSlideView/raw/master/segmentSlide.gif)


#### 使用:

**xib：**

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

**code:**

```
         // 代码创建 需要去掉属性的IBOutlet
      	self.segmentView = GLSegmentSlideView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
        self.segmentView.titleArray = titles
        self.segmentView?.delegate = self
        self.view.addSubview(self.segmentView!)


```


 

 **如有意见，欢迎issue**
