//
//  ViewController.swift
//  MyCalendarApp
//
//完成版

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.calendar.dataSource = self
            self.calendar.delegate = self
            labelDate.text = getToday(format: "yyyy/MM/dd")
            let realm = try! Realm()
            var result = realm.objects(Event.self)
            result = result.filter("date = '\(labelDate.text!)'")
            print(result)
            for ev in result {
                if ev.date == labelDate.text! {
                    scheduleLabel.text = ev.event
                    scheduleLabel.textColor = .black
                    view.addSubview(scheduleLabel)
                }
            }
        if scheduleLabel.text == ""||scheduleLabel.text == "スケジュール内容"{
            scheduleLabel.text = "スケジュールはありません"
            scheduleLabel.textColor = .lightGray
            view.addSubview(scheduleLabel)
        }
        }
    
    func getToday(format:String = "yyyy/MM/dd") -> String{
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {//VCが表示されるごとにスケジュールの予定を表示
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(labelDate.text!)'")
        print(result)
        for ev in result {
            if ev.date == labelDate.text! {
                scheduleLabel.text = ev.event
                scheduleLabel.textColor = .black
                view.addSubview(scheduleLabel)
            }
        }
    }


        fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
        
        fileprivate lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        // 祝日判定を行い結果を返すメソッド
        func judgeHoliday(_ date : Date) -> Bool {
            //祝日判定用のカレンダークラスのインスタンス
            let tmpCalendar = Calendar(identifier: .gregorian)
            
            // 祝日判定を行う日にちの年、月、日を取得
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            
            let holiday = CalculateCalendarLogic()
            
            return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        }
        
        // date型 -> 年月日をIntで取得
        func getDay(_ date:Date) -> (Int,Int,Int){
            let tmpCalendar = Calendar(identifier: .gregorian)
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            return (year,month,day)
        }
        
        //曜日判定
        func getWeekIdx(_ date: Date) -> Int{
            let tmpCalendar = Calendar(identifier: .gregorian)
            return tmpCalendar.component(.weekday, from: date)
        }
        
        // 土日や祝日の日の文字色を変える
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            //祝日判定をする
            if self.judgeHoliday(date){
                return UIColor.red
            }
            
            //土日の判定
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {
                return UIColor.red
            }
            else if weekday == 7 {
                return UIColor.blue
            }
            
            return nil
        }
        
        
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
            
            scheduleLabel.text = "スケジュールはありません"
            scheduleLabel.textColor = .lightGray
            view.addSubview(scheduleLabel)
            
            let tmpDate = Calendar(identifier: .gregorian)
            let year = tmpDate.component(.year, from: date)
            let month = tmpDate.component(.month, from: date)
            let day = tmpDate.component(.day, from: date)
            let m = String(format: "%02d", month)
            let d = String(format: "%02d", day)
            
            let da = "\(year)/\(m)/\(d)"
            
            //クリックしたら、日付が表示される。
            labelDate.text = "\(year)/\(m)/\(d)"
            view.addSubview(labelDate)
            
            //スケジュール取得
            let realm = try! Realm()
            var result = realm.objects(Event.self)
            result = result.filter("date = '\(da)'")
            print(result)
            for ev in result {
                if ev.date == da {
                    scheduleLabel.text = ev.event
                    scheduleLabel.textColor = .black
                    view.addSubview(scheduleLabel)
                }
            }
            
            if scheduleLabel.text == ""{
                
                scheduleLabel.text = "スケジュールはありません"
                scheduleLabel.textColor = .lightGray
                view.addSubview(scheduleLabel)
                
            }
        
        }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        if labelDate.text! == ""||scheduleLabel.text == "スケジュールはありません"||scheduleLabel.text == ""{
            
        }else{//削除ボタンを押下した際のアラート・削除の制御
            let alert = UIAlertController(title: "\(labelDate.text!)の予定を削除します", message: "削除しますか？", preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default,handler:{ (UIAlertAction) in
                print("Delete")
                let realm = try! Realm()
                let results = realm.objects(Event.self).filter("event='\(self.scheduleLabel.text!)'")//データベースの予定=scheduleLabelになるものをクエリ
                print(results)
                try! realm.write {
                    realm.delete(results)
                }
                self.scheduleLabel.text = "スケジュールはありません"
                self.scheduleLabel.textColor = .lightGray
            })
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                print("Cancel")
            }
            
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
        }
        
    }
    
    


