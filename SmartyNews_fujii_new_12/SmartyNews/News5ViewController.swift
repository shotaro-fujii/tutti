//
//  News5ViewController.swift
//  SmartyNews
//
//  Created by 竹居 直哉 on 2017/04/28.
//  Copyright © 2017年 竹居 直哉. All rights reserved.
//

import UIKit
import SDWebImage

class News5ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate, XMLParserDelegate {
    
    var urlArray = [String]()
    
    var tableView:UITableView = UITableView()
    
    var refreshControl:UIRefreshControl!
    
    var webView:UIWebView = UIWebView()
    
    var goButton:UIButton!
    
    var backButton:UIButton!
    
    var cancelButton:UIButton!
    
    var dotsView:DotsLoader! = DotsLoader()
    
    var parser = XMLParser()
    var totalBox = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = String()
    var titleString = NSMutableString()
    var linkString = NSMutableString()
    var urlString = String()
    
    var mypage = [String]()
    var myTotalBox2 = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景画像を作る
        let imageView = UIImageView()
        imageView.frame = self.view.bounds
        imageView.image = UIImage(named: "tutti.jpg")
        self.view.addSubview(imageView)
        
        //        //引っ張って更新
        //        refreshControl = UIRefreshControl()
        //        refreshControl.tintColor = UIColor.white
        //        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        //        if UserDefaults.standard.object(forKey: "array") != nil{
        //            mypage = UserDefaults.standard.object(forKey: "array") as! [String]
        //        }
        
        //tableViewを作成する
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        tableView.backgroundColor = UIColor.clear
        //        tableView.addSubview(refreshControl)
        self.view.addSubview(tableView)
        
        //webView
        webView.frame = tableView.frame
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        self.view.addSubview(webView)
        webView.isHidden = true
        
        //1つ進むボタン
        goButton = UIButton()
        goButton.frame = CGRect(x: self.view.frame.width-50, y: self.view.frame.size.height-128, width: 50, height: 50)
        goButton.setImage(UIImage(named:"go.png"), for: .normal)
        goButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        self.view.addSubview(goButton)
        
        //戻るボタン
        backButton = UIButton()
        backButton.frame = CGRect(x: 10, y: self.view.frame.size.height-120, width: 50, height: 50)
        backButton.setImage(UIImage(named:"back.png"), for: .normal)
        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        //キャンセルボタン
        cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 10, y: 80, width: 50, height: 50)
        cancelButton.setImage(UIImage(named:"cancel.png"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        
        //ドッツビュー
        dotsView.frame = CGRect(x: 0, y: self.view.frame.size.height/3, width: self.view.frame.size.width, height: 100)
        dotsView.dotsCount = 5
        dotsView.dotsRadius = 10
        self.view.addSubview(dotsView)
        
        dotsView.isHidden = true
        
        //xmlを解析する（パース）
        //        let url:String = "https://www.cnet.com/rss/how-to/"
        //        let urlToSend:URL = URL(string: url)!
        //        parser = XMLParser(contentsOf:urlToSend)!
        //        totalBox = []
        //        parser.delegate = self
        //        parser.parse()
        //        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    //画面が開かれるたびに実行される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myTotalBox2 = NSArray()
        myTotalBox2 = []
        
        //アプリ内にmyTotalBoxというキー値で保存された配列myTotalBoxを取り出す
        if UserDefaults.standard.object(forKey: "myTotalBox") != nil{
            myTotalBox2 = UserDefaults.standard.object(forKey: "myTotalBox") as! NSArray
        }
        
        print("ユーザーデフォルトから取り出した")
        print(myTotalBox2)
        
        tableView.reloadData()
        
    }
    
    //    func refresh(){
    //
    //        perform(#selector(delay), with: nil, afterDelay: 2.0)
    //
    //    }
    
    //    func delay(){
    //
    //        //xmlを解析する（パース）
    //        let url:String = "https://www.cnet.com/rss/how-to/"
    //        let urlToSend:URL = URL(string: url)!
    //        parser = XMLParser(contentsOf:urlToSend)!
    //        totalBox = []
    //        parser.delegate = self
    //        parser.parse()
    //        tableView.reloadData()
    //
    //        refreshControl.endRefreshing()
    //
    //    }
    
    //webViewを１ページ進める
    func nextPage(){
        
        webView.goForward()
        
    }
    
    //webViewを１ページ戻す
    func backPage(){
        
        webView.goBack()
        
    }
    
    //webViewを隠す
    func cancel(){
        
        webView.isHidden = true
        goButton.isHidden = true
        backButton.isHidden = true
        cancelButton.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return totalBox.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTotalBox2.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = (myTotalBox2[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.black
        
        cell.detailTextLabel?.text = (myTotalBox2[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 9.0)
        cell.detailTextLabel?.textColor = UIColor.white
        
        //        let urlStr = urlArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //        let url:URL = URL(string:urlStr)!
        //
        //        cell.imageView?.sd_setImage(with: url,placeholderImage:UIImage(named:"placeholderImage.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //webViewを表示する
        let linkURL = (myTotalBox2[indexPath.row] as AnyObject).value(forKey: "link") as? String
        //        let urlStr = linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url:URL = URL(string: linkURL!)!//文字列のリンクをurl型に変換
        let urlRequest = NSURLRequest(url: url)
        webView.loadRequest(urlRequest as URLRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        dotsView.isHidden = false
        dotsView.startAnimating()  //dotsViewが動き出す
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        dotsView.isHidden = true
        dotsView.stopAnimating()
        webView.isHidden = false
        goButton.isHidden = false
        backButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    //タグを見つけたとき
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "item"{
            
            //変数の初期化をする
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
    
    //タグの間にデータがあったとき（開始タグと終了タグでくくられた箇所にデータが存在したときに実行されるメソッド）
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title"{
            
            titleString.append(string)
            
        }else if element == "link"{
            
            linkString.append(string)
            
        }
        
    }
    
    //タグの終了を見つけたとき
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //itemという要素の中にあるなら
        if elementName == "item"{
            
            //titleString(linkString)の中身が空でないなら
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
