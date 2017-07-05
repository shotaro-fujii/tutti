

import UIKit
import SDWebImage

class News1ViewController: UIViewController,UIWebViewDelegate,XMLParserDelegate , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var urlArray = [String]()

    
    var myCollectionView : UICollectionView!
    
    var refreshControl:UIRefreshControl!
    
    var webView:UIWebView = UIWebView()
    
    var goButton:UIButton!
    
    var backButton:UIButton!
    
    var cancelButton:UIButton!
    
    var clipButton:UIButton!
    
    var cellSize:CGFloat!
    
    var title_array = [String]()
    var link_array = [String]()
    
    var mytitle = String()
    var mylink = String()
    
    var dotsView:DotsLoader! = DotsLoader()
    
    var parser = XMLParser()
    var totalBox = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = String()
    var titleString = NSMutableString()
    var linkString = NSMutableString()
    var urlString = String()
    
    //mypage用
    var myTotalBox = NSMutableArray()
    var myElements = NSMutableDictionary()
    var myTitleString = NSMutableString()
    var myLinkString = NSMutableString()
    
    var mystring = String()
    
    
    

    
    
    
    
    //-----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //-----------------------------------
        
        //スクリーンサイズの取得
        //スクリーンの幅
        let screenWidth = UIScreen.main.bounds.size.width;
        //スクリーンの高さ
        let screenHeight = UIScreen.main.bounds.size.height;
        
        
        //引っ張って更新
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        
        //collectionViewを作成する
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        // Cell一つ一つの大きさ.
        //layout.itemSize = CGSize(width:90, height:90)
        
        cellSize = self.view.frame.width
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width:0,height:0)
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        // Cellに使われるクラスを登録.
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.addSubview(refreshControl)
        //myCollectionView.backgroundColor = UIColor.white
        
        
        self.view.addSubview(myCollectionView)
        
        
        
        //webView
        webView.frame = myCollectionView.frame
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        self.view.addSubview(webView)
        webView.isHidden = true
        
        //1つ進むボタン
        goButton = UIButton()
        goButton.frame = CGRect(x: self.view.frame.size.width - 50, y:self.view.frame.size.height - 128 , width: 50, height: 50)
        goButton.setImage(UIImage(named:"go.png"), for: .normal)
        goButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        self.view.addSubview(goButton)
        
        //戻るボタン
        backButton = UIButton()
        backButton.frame = CGRect(x: 10, y:self.view.frame.size.height - 128, width: 50, height: 50)
        backButton.setImage(UIImage(named:"back.png"), for: .normal)
        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        //キャンセルボタン
        cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 10, y:80, width: 50, height: 50)
        cancelButton.setImage(UIImage(named:"cancel.png"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        
        
        //クリップボタン
        clipButton = UIButton()
        clipButton.frame = CGRect(x: self.view.frame.width-100, y: 80, width: 70, height: 50)
        clipButton.setImage(UIImage(named:"clip.png"), for: .normal)
        clipButton.addTarget(self, action: #selector(clip), for: .touchUpInside)
        self.view.addSubview(clipButton)
        
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        clipButton.isHidden = true
        
        
        //ドッツビュー
        dotsView.frame = CGRect(x: 0, y: self.view.frame.size.height/3, width: self.view.frame.size.width, height: 100)
        dotsView.dotsCount = 5
        dotsView.dotsRadius = 10
        self.view.addSubview(dotsView)
        
        dotsView.isHidden = true
        
        
        //xmlを解析する(パース)
        //let url:String = "http://192.168.11.34//?tag=diet,nyusankin&feed=rss2"//タグを指定してパースする場合
        //let url:String = "http://192.168.11.34/?feed=rss2"
        let url:String = "http://localhost:8888/?feed=rss2&cat=2"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=4"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=3"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=6"
        
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf:urlToSend)!
        totalBox = []
        parser.delegate = self
        parser.parse()
        myCollectionView.reloadData()
        
        /*
         //画面に触れていることを検出する
         let tapGesture = UITapGestureRecognizer(target: self,action: #selector(self.button_animate(_:)))
         let myView = UIView(frame: CGRect(x:0, y:0, width:screenWidth, height:screenHeight))
         self.view.sendSubview(toBack:myView)
         myView.tag = 1
         myView.addGestureRecognizer(tapGesture)
         view.addSubview(myView)
         */
        


        
    }
    

    
    //--------------------------------------------------------------------------------------------
    
    

    
    
    
    func refresh(){
        
        perform(#selector(delay), with: nil, afterDelay: 2.0)
        
    }
    
    
    func delay(){
        
        //xmlを解析する(パース)
        urlArray = [String]()
        //let url:String = "http://192.168.11.34//?tag=diet,nyusankin&feed=rss2"
        //let url:String = "http://192.168.11.34/?feed=rss2"
        let url:String = "http://localhost:8888/?feed=rss2&cat=2"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=4"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=3"
        //let url:String = "http://192.168.11.34/?feed=rss2&cat=6"
        
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf:urlToSend)!
        totalBox = []
        
        parser.delegate = self
        parser.parse()
        myCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //webViewを1ページ進める
    func nextPage(){
        
        webView.goForward()
    }
    
    //webViewを1ページ戻す
    func backPage(){
        
        webView.goBack()
        
    }
    
    //webViewを隠す
    func cancel(){
        
        webView.isHidden = true
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        clipButton.isHidden = true
    }
    
    
    //クリップボタンを押したとき
    func clip(){
        
        //変数の初期化をする
        myElements = NSMutableDictionary()
        myElements = [:]
        myTitleString = NSMutableString()
        myTitleString = ""
        myLinkString = NSMutableString()
        myLinkString = ""
        
        myTitleString.append(mytitle)
        //        title_array.append(mytitle)
        //        UserDefaults.standard.set(title_array, forKey: "title_array")
        //        print("ユーザーデフォルトに保存成功")
        //        print(title_array)
        
        //elementsにキー値を付与しながらtitleString(linkString)をセットする
        myElements.setObject(myTitleString, forKey: "title" as NSCopying)
        
        myLinkString.append(mylink)
        //        link_array.append(mylink)
        //        UserDefaults.standard.set(link_array, forKey: "link_array")
        //        print("ユーザーデフォルトに保存成功")
        //        print(link_array)
        
        //elementsにキー値を付与しながらtitleString(linkString)をセットする
        myElements.setObject(myLinkString, forKey: "link" as NSCopying)
        
        //myTotalBoxの中にmyElementsを入れる
        myTotalBox.add(myElements)
        
        UserDefaults.standard.set(myTotalBox, forKey: "myTotalBox")
        print("ユーザーデフォルトに保存成功")
        print(myTotalBox.count)
        print(myTotalBox.lastObject!)
        
        let postString = "name=\(myTotalBox.lastObject!)"
        //        let postString = myTotalBox.lastObject as! String
        
        //        var request = URLRequest(url: URL(string: "http://219.94.253.104/submit.php")!)
        var request = URLRequest(url: URL(string: "http://192.168.11.120/submit.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        //        request.httpBody = (myTotalBox.lastObject! as AnyObject).data
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            print("response: \(response!)")
            
            let phpOutput = String(data: data!, encoding: .utf8)!
            print("php output: \(phpOutput)")
        })
        task.resume()
        
    }
    
    
    
    //Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalBox.count
    }
    
    
    
    
    //Cellに値を設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                                             for: indexPath as IndexPath)
        //print(cellSize)
        
        // Labelを作成
        let label: UILabel = UILabel(frame:CGRect(x:0,y:0,width:cellSize-50,height:cellSize))
        label.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
        
        
        // Labelを生成.
        let back_Label = UILabel(frame: CGRect(x:0, y:0, width:cellSize, height:cellSize))
        back_Label.text = ""
        back_Label.textAlignment = NSTextAlignment.center
        
        //ラベルの文字色
        label.textColor = UIColor.white
        
        label.textAlignment = NSTextAlignment.left
        
        // サムネイルいっぱいにラベルを表示
        label.layer.position = CGPoint(x:((cellSize-50)/2+25),y:cellSize-330)
        
        
        // lightGrayのalphaを調整する
        let background = UIColor.black.withAlphaComponent(0.2)
        // ラベルの背景色
        back_Label.backgroundColor = background
        self.view.addSubview(back_Label)
        
        
        // 文字のシャドウの設定
        //label.shadowColor = UIColor.black
        
        // UILabelの枠を丸くする.
        //label.layer.masksToBounds = true
        
        // 丸くするコーナーの半径.
        //label.layer.cornerRadius = 10.0
        
        label.numberOfLines = 5
        //label.adjustsFontSizeToFitWidth = true //文字をセル幅内に自動であわせる
        //label.minimumScaleFactor = 0.6 //最小でも60%までしか縮小しない場合
        
        let urlStr = urlArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url:URL = URL(string:urlStr)!
        
        label.font = UIFont.boldSystemFont(ofSize:32)
        
        label.font = UIFont(name: "HiraMinProN-W3", size: 32)
        
        //let url = URL(string: "http://192.168.11.34/wp-content/uploads/2017/06/1-768x768.jpeg")
        let data = try? Data(contentsOf: url)
        let iv = UIImageView(image:UIImage(data: data!));
        iv.frame = CGRect(x:0, y:0, width:cellSize , height:cellSize)
        //iv.contentMode = .scaleAspectFit
        
        
        // Cellに追加.
        cell.addSubview(iv)
        cell.addSubview(back_Label)
        cell.addSubview(label)
        
        return cell
    }
    
    
    //Cellが選択された際に呼び出される
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
        //WebViewを表示する
        let titleStr = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
        mytitle = titleStr!
        let linkURL = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        let urlStr = linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        mylink = linkURL!
        print(mylink)
        let url:URL = URL(string: urlStr!)!//文字列のリンクをurl型に変換
        let urlRequest = NSURLRequest(url: url)
        webView.loadRequest(urlRequest as URLRequest)
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        dotsView.isHidden = false
        dotsView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        dotsView.isHidden = true
        dotsView.stopAnimating()
        webView.isHidden = false
        goButton.isHidden  = false
        backButton.isHidden = false
        cancelButton.isHidden = false
        clipButton.isHidden = false
        
    }
    
    
    //タグを見つけた時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "item"{
            
            elements = NSMutableDictionary()
            elements = [:]
            titleString = NSMutableString()
            titleString = ""
            linkString = NSMutableString()
            linkString = ""
            urlString = String()
            
        }else if element == "media:thumbnail"{
            
            urlString = attributeDict["url"]!
            
            urlArray.append(urlString)
            
            
        }
        
    }
    
    
    
    //タグの間にデータがあったとき(開始タグと終了タグでくくられた箇所にデータが存在したときに実行されるメソッド)
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title"{
            
            titleString.append(string)
            //print(titleString)
            
        }else if element == "link"{
            
            linkString.append(string)
        }
        
    }

    
    
    //タグの終了を見つけたとき
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //itemという要素の中にあるなら、
        if elementName == "item"{
            
            //titleString(linkString)の中身が空でないなら、
            if titleString != ""{
                
                //elementsにキー値を付与しながらtitleString(linkString)をセットする
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            
            if linkString != ""{
                
                //elementsにキー値を付与しながらtitleString(linkString)をセットする
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            elements.setObject(urlString, forKey: "url" as NSCopying)
            
            //totalBoxの中にelementsを入れる
            totalBox.add(elements)
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

