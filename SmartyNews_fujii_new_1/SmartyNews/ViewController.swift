//
//  ViewController.swift
//  SmartyNews
//
//  Created by 竹居 直哉 on 2017/04/28.
//  Copyright © 2017年 竹居 直哉. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    var pageMenu:CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var controllerArray : [UIViewController] = []
        
        var controller1:News1ViewController = News1ViewController()
        controller1.title = "食"
        controllerArray.append(controller1)
        
        var controller2:News2ViewController = News2ViewController()
        controller2.title = "運動"
        controllerArray.append(controller2)
        
        var controller3:News3ViewController = News3ViewController()
        controller3.title = "癒し"
        controllerArray.append(controller3)
        
        var controller4:News4ViewController = News4ViewController()
        controller4.title = "学び"
        controllerArray.append(controller4)
        
        var controller5:News5ViewController = News5ViewController()
        controller5.title = "わたしの手帖"
        controllerArray.append(controller5)
        
        let parameters:[CAPSPageMenuOption] = [
        
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:20.0, width:self.view.frame.width, height:self.view.frame.size.height), pageMenuOptions:parameters)
        
        //PageMenuのビューを親のビューに追加
        self.view.addSubview(pageMenu!.view)
        
        //PageMenuのビューをツールバーの後ろに移動させた
        self.view.sendSubview(toBack: pageMenu!.view)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/*
import UIKit
import WBSegmentControl

class ViewController: UIViewController {
    
    var segmentControl: WBSegmentControl!
    var viewPages = UIView()
    var viewLabel = UILabel()
    var pagesController: UIPageViewController!
    var pages: [UIViewController] = []
    
    override func loadView() {
        super.loadView()
        
        initSegmentControl()
        initPagesController()
        
        view.addSubview(segmentControl)
        view.addSubview(viewPages)
        viewPages.addSubview(pagesController.view)
        view.addSubview(viewLabel)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentControl]|", options: .alignAllLeading, metrics: nil, views: ["segmentControl": segmentControl]))
        view.addConstraint(NSLayoutConstraint(item: segmentControl, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: segmentControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        
        viewPages.gestureRecognizers = pagesController.gestureRecognizers
        viewPages.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewPages]|", options: .alignAllLeading, metrics: nil, views: ["viewPages": viewPages]))
        view.addConstraint(NSLayoutConstraint(item: viewPages, attribute: .top, relatedBy: .equal, toItem: segmentControl, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: viewPages, attribute: .bottom, relatedBy: .equal, toItem: viewLabel, attribute: .top, multiplier: 1, constant: 40))
        
        pagesController.view.translatesAutoresizingMaskIntoConstraints = false
        viewPages.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pagesView]|", options: .alignAllLeading, metrics: nil, views: ["pagesView": pagesController.view]))
        viewPages.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pagesView]|", options: .alignAllFirstBaseline, metrics: nil, views: ["pagesView": pagesController.view]))
        
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewLabel]|", options: .alignAllLeading, metrics: nil, views: ["viewLabel": viewLabel]))
        view.addConstraint(NSLayoutConstraint(item: viewLabel, attribute: .top, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: viewLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 40))
        
        viewLabel.textAlignment = .center
        viewLabel.textColor = UIColor.black
        viewLabel.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.selectedIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSegmentControl() {
        segmentControl = WBSegmentControl()
        segmentControl.segments = [
            TextSegment(text: "トップ", otherAttr: "トップ"),
            TextSegment(text: "エンタメ", otherAttr: "エンタメ"),
            TextSegment(text: "スポーツ", otherAttr: "スポーツ"),
            TextSegment(text: "コラム", otherAttr: "コラム"),
            TextSegment(text: "コンピュータ", otherAttr: "コンピュータ"),
            
        ]
        segmentControl.style = .rainbow
        segmentControl.segmentTextFontSize = 9.0
        segmentControl.segmentTextBold = false
        segmentControl.rainbow_colors = [
            UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
            UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
            UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
        ]
        segmentControl.delegate = self
    }
    
    func initPagesController() {
        pagesController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pagesController.dataSource = self
        pagesController.delegate = self
        
        segmentControl.segments.enumerated().forEach { (index, _) in
            //let vc = UIViewController()
            let vc1:UIViewController = News1ViewController()
            let vc2:UIViewController = News2ViewController()
            let vc3:UIViewController = News3ViewController()
            let vc4:UIViewController = News4ViewController()
            let vc5:UIViewController = News5ViewController()
            
//            vc.view.backgroundColor = [
//                UIColor(red:0.91, green:0.18, blue:0.24, alpha:1.00),
//                UIColor(red:1.00, green:0.71, blue:0.26, alpha:1.00),
//                UIColor(red:0.47, green:0.78, blue:0.97, alpha:1.00)
//                ][index % 3]
            pages.append(vc1)
            pages.append(vc2)
            pages.append(vc3)
            pages.append(vc4)
            pages.append(vc5)
            
        }
    }
    
}

extension ViewController: WBSegmentControlDelegate {
    func segmentControl(_ segmentControl: WBSegmentControl, selectIndex newIndex: Int, oldIndex: Int) {
        let targetPages = [pages[newIndex]]
        let direction = ((newIndex > oldIndex) ? UIPageViewControllerNavigationDirection.forward : UIPageViewControllerNavigationDirection.reverse)
        pagesController.setViewControllers(targetPages, direction: direction, animated: true, completion: nil)
        
        if let selectedSegment = segmentControl.selectedSegment as? TextSegment {
            viewLabel.text = selectedSegment.otherAttr
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = pages.index(of: viewController)!
        return index > 0 ? pages[index - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = pages.index(of: viewController)!
        return index < pages.count - 1 ? pages[index + 1] : nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == false {
            guard let targetPage = previousViewControllers.first else {
                return
            }
            guard let targetIndex = pages.index(of: targetPage) else {
                return
            }
            segmentControl.selectedIndex = targetIndex
            pageViewController.setViewControllers(previousViewControllers, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let targetPage = pendingViewControllers.first else {
            return
        }
        guard let targetIndex = pages.index(of: targetPage) else {
            return
        }
        segmentControl.selectedIndex = targetIndex
    }
}
*/
