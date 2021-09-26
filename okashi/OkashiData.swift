//
//  OkashiData.swift
//  okashi
//
//  Created by masaya ishigami on 2021/09/25.
//

import Foundation
import UIKit

//jsonのデータ内のデータを格納するためのもの
struct OkashiItem: Identifiable{
    
    let id = UUID()
    let name: String
    let link: URL
    let image: UIImage
}

class OkashiData:ObservableObject{
    
    //jsonのデータ内のデータを格納するためのもの
    struct ResultJson: Codable{
        
        struct Item: Codable{
            let name: String?
            let url: URL?
            let image: URL?
        }
            //複数要素
            let item: [Item]?
    }
    //okashiItemの構造体を複数保持できる
    //publishedによってプロパティを監視して自動で通知できるようになる
    @Published var okashiList:[OkashiItem]=[]
    
    //第一引数の検索したいワード
    func searchOkashi(keyword:String){
        //ここで検索したキーワードをプリントアウトする
        print("検索キーワードの入力を受け取ったよ"+keyword)
        
        //お菓子の検索キーワードをURLエンコードする 、URLには日本が使えないらしくそのせい
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        
        print("検索キーワードをエンコードできたよ")
        print(keyword_encode)
        //リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&keyword=\(keyword_encode)&format=json&max=10&order=r") else{
            return
        }
        print("URLを整形できたよ")
        print(req_url)
        
    //リクエストに必要な情報を生成
    let req = URLRequest(url: req_url)//reqの定義
    //データ転送を管理するためのセッションを生成
    //delegateがnilなのは、クロージャを使用するため、delegateQueueでクロージャの実行を規制するキューを指定、OperationQueueは非同期処理となり、処理中は他の処理を止めないようにする。同期処理は順番に処理を行なっていくようにする
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //リクエストをタスクとして登録、メインスレッドはプロセスに1つ存在していて、スレッドは複数ある。
        //reqは通信方法が定義されている
        //conpletisonhandlerがクロージャでdata=取得後のデータが格納、responseは通信状態を示す情報が格納される、erroerはエラー内容
        let task = session.dataTask(with: req,completionHandler:{
            (data,response,error) in
            
            //データがダウロード後セッション終了
            session.finishTasksAndInvalidate()
            
            do{//do try catch　エラーハンドリング
                let decoder = JSONDecoder()//json decoderのインスタンス取得
                //受け取ったjsonデータをパースして、構造体resultjsonのデータ構造に合わせて、変数のjsonを格納する
                //iOSではデフォルトでは、HTTPを使ってインターネットに接続できないようになっている。デフォルトではATSが有効になっており、今回は無効に変更することで、通信をできるようにする。
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                //print(json)
                
                if let items = json.item{
                
                self.okashiList.removeAll()//お菓子のリストを初期化
                
                    for item in items{//itemにitemsを一つずつ格納していく
                        
                        if let name = item.name,//値があれば次のカンマの以降のコードを実行
                           let link = item.url,//値があれば次のカンマの以降のコードを実行
                           let imageUrl = item.image,//値が無ければ次の行にデータに処理をうつす
                           let imageData = try? Data(contentsOf: imageUrl),
                           let image = UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal){
                                //1つのお菓子を構造体でまとめて管理
                                let okashi = OkashiItem(name: name, link: link, image: image)
                                //お菓子の配列への追加
                                self.okashiList.append(okashi)
                        }
                        
                    }
                    print("お菓子のデータをリストに格納したよ")
                    print(self.okashiList)
                }
            }catch{
                print("エラーが出た")
                
            }
            
        })
        task.resume()//ダウンロード開始
    }
}
