//
//  ViewController.swift
//  Tutorial
//
//  Created by Huang Jian-Yu on 2015/7/25.
//  Copyright (c) 2015年 Zitra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var mainViewController: UIViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let haslaunched = defaults.boolForKey("Launched")
        
        //判斷是否是第一次開啟APP
        if haslaunched == false
        {
            //顯示新手導覽(Tutorial)
            self.pageTitles = NSArray(objects: "page1", "page2", "page3")
            self.pageImages = NSArray(objects: "page1","page2","page3")
        
            self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
            self.pageViewController.dataSource = self
        
            var startVC = self.viewControllerAtIndex(0) as ContentViewController
            var viewControllers = NSArray(object: startVC)
    
            self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
            
            self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 120)
        
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
        else
        {
            //顯示首頁
            self.mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! UIViewController
            self.addChildViewController(self.mainViewController)
            self.view.addSubview(self.mainViewController.view)
            self.mainViewController.didMoveToParentViewController(self)
        }
        
    }
    
    
    @IBAction func Close(sender: AnyObject) {
        //儲存使用者已經閱讀過新手導覽
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "Launched")
        
        //導頁(Main)
        self.mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! UIViewController
        self.pageViewController.presentViewController(mainViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        if((self.pageTitles.count==0) || (index >= self.pageTitles.count))
        {
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    
    // MARK: - Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index==2
        {
            self.startButton.hidden = false
        }
        else
        {
            self.startButton.hidden = true
        }

        if(index==0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index==2
        {
            self.startButton.hidden = false
        }
        else
        {
            self.startButton.hidden = true
        }
        
        if(index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if(index == self.pageTitles.count)
        {
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
    
}

