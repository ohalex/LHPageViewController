# LHPageViewController

##What
  LHPageViewController is a page view controller that have features we may find in many news apps. It contains two components, that is, LHScrollList and LHPageView,both of which can be used seperately according to your needs.
  
##LHPageViewController的基本组成
LHPageViewController包含三个基本的类：
- LHScrollList：可滑动的选择列表，固定高度38，背景半透明。使用如下：
    
<pre><code>
LHScrollList * scrollList = [[LHScrollList alloc]initWithFrame:frame];
scrollList.titles = titles;
scrollList.delegate = self;
</code></pre>    

<pre><code>
//点击滑动列表项时调用
-(void)scrollList:(LHScrollList *)scrollList didClickItemAtIndex:(NSInteger)index;
</code></pre>

<pre><code>
//移动至索引项
[self.scrollList moveToItemAtIndex:index];
</code></pre>

- LHPageView：可滑动的内容页面容器，使用如下：
<br>
    
<pre><code>
LHPageView * pageView = [[LHPageView alloc] initWithFrame:frame];
[pageView initializeWithNumberOfPages:self.childViewControllers.count];
[pageView addPageWithView:controller.view atIndex:index];
pageView.delegate = self;
</code></pre> 

<pre><code>
//停止拖动pageView时调用
-(void)pageView:(LHPageView *)pageView WillEndDraggingAtIndex:(NSInteger)index;
</code></pre> 

<pre><code>
//移动至索引页面
[self.pageView moveToPageAtIndex:index];
</code></pre>
    
- LHPageController：整合前面两个View，使用如下：
    
<pre><code>
//vc1为控制器1，其title对应LHSCrollList的列表项title，若无则title默认为“无标题”
LHPageController * page = [[LHPageController alloc]initWithControllers:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7]];
page.view.frame = frame;
</code></pre>
--
