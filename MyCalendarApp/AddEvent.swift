//
//  AddEvent.swift
//  MyCalendarApp
//

import UIKit
import RealmSwift

class AddEvent: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var eventTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTF.delegate = self

        // Do any additional setup after loading the view.
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        datePicker.addTarget(self, action: #selector(picker(_:)), for: .valueChanged)
        view.addSubview(selectLabel)
        selectLabel.text = getToday(format: "yyyy/MM/dd")
        
    }
    
    func getToday(format:String = "yyyy/MM/dd") -> String{
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
        
    }
    
    @objc func picker(_ sender:UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        selectLabel.text = formatter.string(from: sender.date)
        view.addSubview(selectLabel)
        
    }
    
    
    @IBAction func addEvent(_ sender: Any) {
        
        print("データ書き込み開始")
        
        let realm = try! Realm()
        
        try! realm.write {
            //日付表示の内容とスケジュール入力の内容が書き込まれる
            let inEventTF = eventTF.text!.trimmingCharacters(in: .whitespaces)
            print(eventTF.text)
            print(inEventTF)
            if inEventTF == "" {
                let alert = UIAlertController(title: "エラー", message: "スケジュールが空白です", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
                    print("OK")
                }
                alert.addAction(okButton)
                present(alert, animated: true, completion: nil)
            } else {
                let Events = [Event(value: ["date": selectLabel.text, "event": eventTF.text])]
                realm.add(Events)
                print("データ書き込み中")
            }
        }
        
        print("データ書き込み完了")
        eventTF.text = ""
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    //リターンキーでキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードが閉じる
        textField.resignFirstResponder()
        return true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
