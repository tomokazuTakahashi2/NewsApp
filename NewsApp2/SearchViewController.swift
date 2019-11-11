//
//  SearchViewController.swift
//  NewsApp2
//
//  Created by Raphael on 2019/11/06.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 検索結果を表示するSearchResultsControllerのインスタンス化を生成
        let searchResultViewController = SearchResultViewController()
        
//UISearchControllerのインスタンス生成・検索画面をSearchResultsControllerに指定
        searchController = UISearchController(searchResultsController: searchResultViewController)
        //このクラスを表示の起点とする
        self.definesPresentationContext = true
        //ナビゲーションバーに検索窓を表示する
        self.navigationItem.searchController = searchController
        //ナビゲーションバーにタイトルを入れる
        self.title = "検索"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        //検索処理をどのクラスで処理をするかを指定
        //SearchResultViewControllerを指定
        searchController.searchResultsUpdater = searchResultViewController
    }
    
}
