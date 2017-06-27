//
//  CustomUICollectionViewCell.swift
//  SmartyNews
//
//  Created by 藤井翔大朗 on 2017/06/26.
//  Copyright © 2017年 竹居 直哉. All rights reserved.


import UIKit

class CustomUICollectionViewCell : UICollectionViewCell{
    
    var textLabel : UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成.
        textLabel = UILabel(frame: CGRect(x:0, y:80, width:frame.width, height:50))
        textLabel?.text = "nil"
        textLabel?.backgroundColor = UIColor.white
        textLabel?.textAlignment = NSTextAlignment.center
        
        
        let url = URL(string: "http://192.168.11.34/wp-content/uploads/2017/06/5-300x300.jpg")
        let data = try? Data(contentsOf: url!)
        let iv = UIImageView(image:UIImage(data: data!));
        iv.contentMode = .scaleAspectFit
        
        
        // Cellに追加.

        self.contentView.addSubview(iv)
        self.contentView.addSubview(textLabel!)
    }
    
}
