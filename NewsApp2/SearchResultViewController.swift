//
//  SearchResultViewController.swift
//  NewsApp2
//
//  Created by Raphael on 2019/11/07.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit
import SafariServices

class SearchResultViewController: UITableViewController,UISearchResultsUpdating {
    
    //取得したデータを保持する配列を追加
    var dataList:[SampleModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()
    
        //カスタムセルNewsCellを使用するため、UITableViewに登録
        let nib = UINib(nibName: "NewsCell",bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsCell")
    }
    //UISearchBarの文字列に何かしら変化があったら呼ばれる
    func updateSearchResults(for searchController: UISearchController) {   //UISearchControllerの検索窓に入力した文字列を取得
        if let text = searchController.searchBar.text{
            //データ取得関数を呼び出す
            self.reloadListDatas(text)
        }
    }
    
    func reloadListDatas(_ text:String){
        //文字列がからの時は処理を行わない
        if text.isEmpty{
            return
        }
        //セッション用のコンフィグを設定・今回はデフォルトの設定
        let config = URLSessionConfiguration.default
        //NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        //検索する文字列が日本語の場合もあるため、エンコードする
        let urlString = "https://demo.wp-api.org/wp-json/wp/v2/posts/" + "?search=" + text
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        //通信タスクを設定
        let task = session.dataTask(with: url){(data,response,error)in
            
        //エラーが発生したら、アラートを表示して終了
        if error != nil {
            let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました。", preferredStyle:
                UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "OK", style:
                UIAlertAction.Style.cancel, handler: nil))
            self.present(controller,animated: true,completion: nil)
            return
        }
        //JSON形式にデータ変換
        guard let jsonData: Data = data  else {
            let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(controller,animated: true,completion: nil)
            return
        }
        self.dataList = try! JSONDecoder().decode([SampleModel].self, from: jsonData)
        //メインスレッドに処理を戻す
        DispatchQueue.main.async {
            //検索結果が０件だった場合はアラートを出す
            if self.dataList.isEmpty{
                let controller : UIAlertController = UIAlertController(title: nil, message: "検索結果はありませんでした", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller,animated: true,completion: nil)
                return
            }
            //最新のデータに更新する
            self.tableView.reloadData()
        }
    }
    //タスクを実行
    task.resume()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションは１つ
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得した記事だけ表示
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //NewsCellのインスタンスを生成・すでに作られている場合は再利用
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)as!NewsCell
        
        //データを取り出し、日付とタイトルを入れる
        let data = dataList[indexPath.row]
        cell.dateLabel.text = data.dateString
        cell.titleLabel.text = data.title.rendered

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択したセルを非表示に戻す
        tableView.deselectRow(at: indexPath, animated: true)
        
        //データを取り出し、SFSafariViewControllerで表示させる
        let data = dataList[indexPath.row]
        if let url = URL(string: data.link){
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller,animated: true,completion: nil)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
