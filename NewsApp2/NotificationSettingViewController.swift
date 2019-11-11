//
//  NotificationSettingViewController.swift
//  NewsApp2
//
//  Created by Raphael on 2019/11/08.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit
import UserNotifications

//通知設定画面
class NotificationSettingViewController: UIViewController {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ナビゲーションバーにタイトルを入れる
        self.title = "通知設定"
        
        //通知を管理するオブジェクトを一旦オフ・操作不可にする
        notificationSwitch.isOn = false
        datePicker.isEnabled = false
        notificationButton.isEnabled = false
        //これから予定されている通知を取得
        UNUserNotificationCenter.current().getPendingNotificationRequests{
            (requests)in
            //これから予定されている通知がある＝通知の設定は行われている
            if requests.count > 0 {
                //UIの変更を伴うので、メインスレッドで処理を行わせる
                DispatchQueue.main.async {
                    //スイッチをオンに変更
                    self.notificationSwitch.isOn = true
                    //時間の変更、通知設定のボタン押下を行えるようにする
                    self.datePicker.isEnabled = true
                    self.notificationButton.isEnabled = true
                }
            }
        }
        
    }
    
    //UISwitchを押した時の処理
    @IBAction func onNotificationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn{
            //ボタン、UIDatePickerを有効にする
            datePicker.isEnabled = true
            notificationButton.isEnabled = true
        }else{
            //ボタン、UIDatePickerを無効にする
            datePicker.isEnabled = false
            notificationButton.isEnabled = false
            //予定されている通知を解除する
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            //通知を解除した旨の表示を行う
            let controller = UIAlertController(title: nil, message: "通知を解除しました", preferredStyle: UIAlertController.Style.alert)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(controller,animated: true,completion: nil)
        }
    }
    //「通知を設定」のボタンを押した時の処理
    @IBAction func onNotificationButtonTapped(_ sender: UIButton) {
        //通知を管理するクラスのシングルトンを取得
        let center = UNUserNotificationCenter.current()
        //datePickerで指定された時間を取得
        let date = datePicker.date
        
    //通知を許可するリクエストを表示する（すでに許可する・しないの画面が出ていれば表示されずに中の処理がすぐに処理される）※granted…するか否か
        center.requestAuthorization(options: [.alert,.sound], completionHandler: { granted, error in
            //エラーチェック
            if error != nil{
                let controller = UIAlertController(title: nil, message: "通知設定時にエラーが発生しました", preferredStyle:
                    UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(controller,animated: true,completion: nil)
                return
            }
            //許可する・しないの結果によって処理を変える
            if granted{
                //予定されている全ての通知の設定を削除してから通知の設定を行う
                center.removeAllDeliveredNotifications()
                //通知内容を設定
                let content = UNMutableNotificationContent()
                //通知のタイトル
                content.title = "最新の記事をチェックしましょう"
                //通知のサブタイトル
                content.subtitle = "今日はもう記事のチェックはしましたか？"
                //通知の本文
                content.body = "最新のニュースがありますよ！"
                //通知音の設定
                content.sound = UNNotificationSound.default
                //カレンダーのインスタンスを生成
                let calendar = Calendar.current
                //日付や時間を数値で取得できるDateComponentsを作成
                //今回はdatePickerで設定した時間をもとに時間・分のみを取得
                let dateComponents = calendar.dateComponents([.hour,.minute],from: date)
                //どの時間で通知するかを設定するか、繰り返し通知するかの設定
                //dateComponentsで設定した時間で通知。今回は繰り返し通知を行うので、repeatsはtrue
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                //通知の識別子を設定
                let identifier = "NewsNotification"
                //通知の内容と時間をもとにリクエストを作成
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                //通知を設定する
                center.add(request, withCompletionHandler: nil)
                //通知の設定が完了した旨の表示を行う
                let controller = UIAlertController(title: nil, message: "\(dateComponents.hour!)時\(dateComponents.minute!)分に通知する設定を行いました", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(controller,animated: true,completion: nil)
            }else{
                //通知が許可されていない場合はここでアラートを表示
                let controller = UIAlertController(title: nil, message: "通知の設定が許可されていません。設定アプリから通知の設定をご確認ください。", preferredStyle: UIAlertController.Style.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(controller,animated: true,completion: nil)
            }
        })
    }
    //UIButtonItemを押した時の処理
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        //画面を閉じてNewsViewControllerへ戻る処理
        self.dismiss(animated: true, completion: nil)
    }
}
