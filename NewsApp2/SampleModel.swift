import Foundation

struct SampleModel: Codable {
    //記事が公開された日時
    var date:String = ""
    //記事のURL
    var link:String = ""
    //記事のタイトル
    var title: SampleTitleModel = SampleTitleModel()
    struct SampleTitleModel: Codable {
        var rendered: String = ""
    }
    var dateString: String{
        //NSDateFormatterのインスタンスを生成
        let formatter: DateFormatter = DateFormatter()
        
        //受け取るフォーマットを設定
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
       
        //正常にDate型に変換できるか確認
        if let date = formatter.date(from: date){
            //表示するフォーマットを指定
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            //String型に変換を行い、返す
            let str = formatter.string(from: date)
            return str
        }
        //万が一失敗した場合は、そのままdateを返す
        return date
    }
    
}
