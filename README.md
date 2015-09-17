# GLSegmentSlideView

## 标题分类控件

*   描述:

   *该控件一般和UIScrollView一起使用，可根据滑动的距离来实时更新底部线条的位置和宽度，
    宽度是根据每个分割的控件title计算的宽度而定。点击控件通过代理回调给UIScrollView来
    改变ContentOffset来达到控制页数的效果*

*   使用:

  `self.segmentView = GLSegmentSlideView(frame: CGRectMake(0, 64, ScreenWidth, 50), titleArray: ["美甲天下","美","秀美甲大咖"])`

    
  `//MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
    self.segmentView?.updateBottomLineView(scrollView.contentOffset.x)
    }

    //MARK: SegmentSlideViewDelegate
    func didSelectSegment(index: Int) {
    self.contentScrollView!.setContentOffset(CGPointMake(CGFloat(index) * ScreenWidth, 0), animated: true)
    }`
    
    ![](https://github.com/god-long/GLSegmentSlideView/raw/master/segmentSlide.gif)


    *这个比较简单 主要是计算位置而已 后续会继续改进*
