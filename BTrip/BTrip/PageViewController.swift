//
//  MainViewController.swift
//  Vetrip
//
//  Created by Vetech on 15/5/21.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageControl: UIPageControl!
    var pageTitles: [String]!
    var pageImages: [String]!
    
    var pageIndex: Int = 0
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        pageControl.alpha = 0.8
        pageControl.frame.offset(dx: 0, dy: -200)
        
        pageTitles = ["1Over 200 Tips and Tricks", "2Discover Hidden Features", "3Bookmark Favorite Tip", "4Free Regular Update"];
        pageImages = ["page1.png", "page2.png", "page3.png", "page4.png"];
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        var startingViewController = viewControllerAtIndex(self.pageIndex)!
        var viewControllers = [startingViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "startWalkthrough:", userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        timer?.fire()
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer?.invalidate()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex
        if index == 0 || index == NSNotFound {
            return nil
        }
        self.pageIndex = index--
        timer?.invalidate()
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        self.pageIndex  = index++
        timer?.invalidate()
        
        if index == self.pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count {
            return nil
        }
        var pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        pageContentViewController.imageFile = self.pageImages[index]
        pageContentViewController.titleText = self.pageTitles[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
    
    func startWalkthrough(sender: AnyObject?) {
        var startingViewController = viewControllerAtIndex(self.pageIndex)!
        var viewControlllers = [startingViewController]
        self.pageViewController.setViewControllers(viewControlllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageControl.currentPage = self.pageIndex
        
        if ++self.pageIndex >= self.pageImages.count {
            self.pageIndex = 0
        }
    }
    
    typealias Task = (cancel: Bool) -> ()
    func delay(time: NSTimeInterval, task: ()->()) -> Task? {
        
        func dispatch_later(block: ()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        
        var closure: dispatch_block_t? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if cancel == false {
                    dispatch_async(dispatch_get_main_queue(), internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        
        return result
    }
    
    func cancel(task: Task?) {
        task?(cancel: true)
    }
    
}
