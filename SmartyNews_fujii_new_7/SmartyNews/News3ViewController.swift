//
//  News3ViewController.swift
//  SmartyNews
//
//  Created by 竹居 直哉 on 2017/04/28.
//  Copyright © 2017年 竹居 直哉. All rights reserved.
//

import UIKit
import SwiftyJSON


class News3ViewController:UIViewController {
    
    private var appearGraph: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//----------------------------------------------------------------------------------
        
        // UIButtonのインスタンス
        let button = UIButton()
        
        // ボタンのテキスト設定
        button.setTitle("結果を見る", for: .normal)
        
        // ボタンのテキスト色を指定（これがないと白い文字になるため背景と同化して見えない）
        button.setTitleColor(UIColor.blue, for: .normal)
        
        // 大きさの自動調節
        button.sizeToFit()
        
        // 位置を画面中央に
        button.center = self.view.center
        
        // ビューに追加
        self.view.addSubview(button)

        // タップしたときに呼び出すメソッド指定
        button.addTarget(self, action: #selector(graphDataGet), for: .touchUpInside)
        
//----------------------------------------------------------------------------------
        
        // UIImageを作成
        // (グラフ表示画面)
        appearGraph = UIImageView(frame: CGRect(x: 0, y: 0, width: 360, height: 240))
        appearGraph.image = UIImage(named:"noimage.jpg")
        appearGraph.layer.borderColor = UIColor.black.cgColor
        appearGraph.layer.borderWidth = 4.0;
        appearGraph.layer.cornerRadius = 50
        appearGraph.layer.masksToBounds = true
        appearGraph.layer.position = CGPoint(x: view.bounds.width/2, y: self.view.bounds.height/2-160)
        
        
        // UI部品を配置する。
        // (UIImage)
        self.view.addSubview(appearGraph)
        
        
        
//----------------------------------------------------------------------------------
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // ボタンが押された時に呼ばれるメソッド
        func graphDataGet(){
        let url = URL(string: "http://192.168.11.34/get_result_data.php")!
     
//        let url = URL(string: "http://124.219.162.203/kawachi/get_from_predictionresult.php")!
            
            
            print("-----1----")

        let task : URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if(error == nil){

                let result = NSString(data:data!,encoding:String.Encoding.utf8.rawValue)!
                //結果を出力(JSON形式)
                print("-----2----")
                let json = JSON(data: data!)
                print("json = \(json)")
                let row : Int = json.count - 1
                let str : String! = json[row][0]["img_data_base64"].string!
                print("json = \(str)")
                
                
                let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.appearGraph.image = self.String2Image(str)
                }
            }
        }
        
        task.resume()
        print("-----3----")
    }
    
    //StringをUIImageに変換する
    func String2Image(_ imageString:String) -> UIImage?{
        
        //空白を+に変換する
        let base64String = imageString.replacingOccurrences(of: " ", with:"+")
        
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:Data? =
            Data(base64Encoded:base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        //NSDataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess)
            
            //結果を返却
            return img
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
