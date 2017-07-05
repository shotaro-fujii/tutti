

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
        
        var controller6:News6ViewController = News6ViewController()
        controller6.title = "テストタブ"
        controllerArray.append(controller6)
        
        
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

