import UIKit
import SwiftyJSON

class News1ViewController: UIViewController {
    
    
    private var appearGraph: UIImageView!
    
    
    // UIImage のインスタンスを設定
    let image0:UIImage = UIImage(named:"hand")!
    let image1:UIImage = UIImage(named:"glass")!

    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    // UIButton のインスタンスを生成
    let button = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画面の横幅を取得
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height
        
        // 画像を設定
        //button.setImage(image0, for: .normal)
        button.setImage(image1, for: .normal)

        
        let imgView: UIImageView = UIImageView(frame:  CGRect(x: (screenWidth-400)/2, y: ((screenHeight-500)/2)+60, width: 400, height: 500))
        imgView.image = image0
        self.view.addSubview(imgView)
    

        
        // Buttonが画面の中央で横幅いっぱいのサイズになるように設定
        //button.frame = CGRect(x:0, y:0, width:screenWidth+10, height:screenHeight+10)
        

        button.frame = CGRect(x:((screenWidth-393)/2)+20, y:((screenHeight-360)/2)+150, width:393, height:360)

        // ViewにButtonを追加
        self.view.addSubview(button)
        
        // タップされたときのactionをセット
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    
    
    }
    
    
//---------------------------------------------------------------
    
    

    func buttonTapped(sender : AnyObject) {
        
        view.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0.5
            self.button.alpha = 0.0

        })
        print("Tapped!!")
        
        
        

        
        

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            // UI部品を配置する。
            // UIImageを作成
            // (グラフ表示画面)
            self.appearGraph = UIImageView(frame: CGRect(x: 0, y: -50, width: 360, height: 240))
            self.appearGraph.image = UIImage(named:"noimage.jpg")
            
            self.appearGraph.layer.borderColor = UIColor.brown.cgColor
            self.appearGraph.layer.borderWidth = 3.0;
            self.appearGraph.layer.cornerRadius = 10
            self.appearGraph.layer.masksToBounds = true
            self.appearGraph.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2-130)

            
            let url = URL(string: "http://192.168.11.34/get_result_data.php")!
            
            let task : URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if(error == nil){
                    
                    let result = NSString(data:data!,encoding:String.Encoding.utf8.rawValue)!
                    //結果を出力(JSON形式)
                    let json = JSON(data: data!)
                    print("json = \(json)")
                    let row : Int = json.count - 1
                    let str : String! = json[row][0]["img_data_base64"].string!
                    print("json = \(str)")
                    
                    
                    let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        // (UIImage)
                        self.view.addSubview(self.appearGraph)
                        self.appearGraph.image = self.String2Image(str)
                        self.view.alpha = 1.0
                        
                        
                    }
                }
            }
            
            task.resume()
            
        }
        
        

        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
