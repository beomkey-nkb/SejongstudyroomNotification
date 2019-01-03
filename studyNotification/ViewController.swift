//
//  ViewController.swift
//  studyNotification
//
//  Created by 남기범 on 2018. 12. 6..
//  Copyright © 2018년 남기범. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import SwiftSoup
import UserNotifications
import SwiftyJSON
import Firebase
import GoogleSignIn
import FBSDKLoginKit

struct ReservedInformation{
    var room: String
    var seatNumber: String
    var ID: String
    var name: String
    var startTime: String
    var endTime: String
    var extendedNumber: String
    var state: String
    var state1: String
}

class ViewController: UIViewController {

    var now = Date()
    let calendar = Calendar.current//달력- 현재 날짜를 받아온다.
    var year:Int = 0
    var month:Int = 0
    var day:Int = 0
    var FIRDatabase: DatabaseReference!
    var userNumber = "1"
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var subLabel1: UILabel!
    @IBOutlet weak var subLabel2: UILabel!
    @IBOutlet weak var subLabel3: UILabel!
    @IBOutlet weak var subLabel4: UILabel!
    @IBOutlet weak var subLabel5: UILabel!
    @IBOutlet weak var subLabel6: UILabel!
    @IBOutlet weak var subLabel7: UILabel!
    @IBOutlet weak var subLabel8: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var seatNumberLabel: UILabel!
    @IBOutlet weak var extendedNumberLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var mainView1: ViewCustom!
    @IBOutlet weak var subView1: ViewCustom!
    @IBOutlet weak var mainView2: ViewCustom!
    @IBOutlet weak var subView2: ViewCustom!
    @IBOutlet weak var mainView3: ViewCustom!
    @IBOutlet weak var subView3: ViewCustom!
    @IBOutlet weak var mainView4: ViewCustom!
    @IBOutlet weak var subView4: ViewCustom!
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        //키보드를 사라지게 해줌
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            print(user)
            // [END_EXCLUDE]
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
//    func toolbarSetupViews(){
//        //키보드에 버튼을 추가하기 위한 함수
//        let toolBar  = UIToolbar()
//        toolBar.sizeToFit()
//
//        let toolBarButton = UIBarButtonItem(title: "검색", style: UIBarButtonItem.Style.plain, target: self, action: #selector(postButton(_:)))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([flexibleSpace,toolBarButton,flexibleSpace], animated: false)
//        userID.inputAccessoryView = toolBar
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase = Database.database().reference()
        let components = self.calendar.dateComponents([.year, .month, .day], from: self.now)
        //현재 정보에서 원하는 정보만 추출(년도,달,일)
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!

        //검색버튼 누르기 전에 숨기기
        subLabel1.isHidden = true
        subLabel2.isHidden = true
        subLabel3.isHidden = true
        subLabel4.isHidden = true
        subLabel5.isHidden = true
        subLabel6.isHidden = true
        subLabel7.isHidden = true
        subLabel8.isHidden = true
        IDLabel.isHidden = true
        NameLabel.isHidden = true
        startTimeLabel.isHidden = true
        EndTimeLabel.isHidden = true
        roomLabel.isHidden = true
        seatNumberLabel.isHidden = true
        extendedNumberLabel.isHidden = true
        stateLabel.isHidden = true
        alertButton.isHidden = true
        mainView1.isHidden = true
        mainView2.isHidden = true
        mainView3.isHidden = true
        mainView4.isHidden = true
        subView1.isHidden = true
        subView2.isHidden = true
        subView3.isHidden = true
        subView4.isHidden = true
        emptyLabel.isHidden = true
        
        postButton((Any).self)
    }
    
    @IBAction func postButton(_ sender: Any) {
        let usercurrent = Auth.auth().currentUser
        var numberstudy = "1"
        self.FIRDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value
            let userEmail = usercurrent?.email
            let dic = values as! [String: [String:Any]]
            for index in dic{
                if (index.value["userEmail"] as! String == userEmail){
                    //유저정보 조회 및 학번 데이터베이스에서 가져오기
                    numberstudy = index.value["studyNumber"] as! String
                    
                    let txtSeat = numberstudy
                    print(txtSeat)
                    //좌석정보 조회
                    var arrInformation: Array<ReservedInformation> = Array()
                    var number = 0
                    
                    let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)//euc-kr 인코딩을 위한 코드
                    let mainURL = "http://210.107.226.14/seat/UserLog_dli.asp?QUERY=Y&sROOM=0&txtSEAT=\(txtSeat)&start1yy=\(self.year)&start1mm=\(self.month)&start1dd=\(self.day)&end1yy=\(self.year)&end1mm=\(self.month)&end1dd=\(self.day)&chkSEAT=ON&chkDay=ON"
                    var expectedNumber:Int = 4 //예약횟수만큼 보기위한 수
                    var exampleInfo = ReservedInformation(room: "x", seatNumber: "x", ID: "x", name: "x", startTime: "x", endTime: "x", extendedNumber: "x", state: "x", state1: "x")
                    
                    guard let main = URL(string: mainURL) else {
                        print("Error: \(mainURL) doesn't seem to be a valid URL")
                        return
                    }
                    do {
                        
                        let lolMain = try String(contentsOf: main, encoding: String.Encoding(rawValue: encodingEUCKR))
                        //url을 string으로 인코딩
                        let firstconfirm:Document = try SwiftSoup.parse(lolMain)
                        let secondconfirm:Document = try SwiftSoup.parse(lolMain)
                        
                        if ((try firstconfirm.select("body > center > table:nth-child(4)").first()?.empty()) != nil){
                            //테이블 태그가 존재하는지 확인하기
                            while true {
                                if ((try secondconfirm.select("body > center > table:nth-child(4) > tbody > tr:nth-child(\(expectedNumber))").first()?.empty()) != nil) {
                                    //테이블이 있는지 없는지 유무 조사
                                    
                                    
                                    for index in 1..<10{
                                        let doc: Document = try SwiftSoup.parse(lolMain)
                                        let link: Element = try doc.select("body > center > table:nth-child(4) > tbody > tr:nth-child(\(expectedNumber)) > td:nth-child(\(index))").first()!
                                        switch index{
                                        case 1:
                                            exampleInfo.room = try link.text()
                                            break
                                        case 2:
                                            exampleInfo.seatNumber = try link.text()
                                            break
                                        case 3:
                                            exampleInfo.ID = try link.text()
                                            break
                                        case 4:
                                            exampleInfo.name = try link.text()
                                            break
                                        case 5:
                                            exampleInfo.startTime = try link.text()
                                            break
                                        case 6:
                                            exampleInfo.endTime = try link.text()
                                            break
                                        case 7:
                                            exampleInfo.extendedNumber = try link.text()
                                            break
                                        case 8:
                                            exampleInfo.state = try link.text()
                                            break
                                        case 9:
                                            exampleInfo.state1 = try link.text()
                                            break
                                        default:
                                            break
                                        }
                                    }
                                    arrInformation.append(exampleInfo)
                                    expectedNumber+=2
                                }
                                else{
                                    break
                                }
                                
                            }
                            
                            self.IDLabel.text = arrInformation[arrInformation.count-1].ID
                            self.NameLabel.text = arrInformation[arrInformation.count-1].name
                            self.startTimeLabel.text = arrInformation[arrInformation.count-1].startTime
                            self.EndTimeLabel.text = arrInformation[arrInformation.count-1].endTime
                            self.roomLabel.text = arrInformation[arrInformation.count-1].room
                            self.seatNumberLabel.text = arrInformation[arrInformation.count-1].seatNumber
                            self.extendedNumberLabel.text = arrInformation[arrInformation.count-1].extendedNumber
                            self.stateLabel.text = arrInformation[arrInformation.count-1].state
                            
                            
                            
                            self.subLabel1.isHidden = false
                            self.subLabel2.isHidden = false
                            self.subLabel3.isHidden = false
                            self.subLabel4.isHidden = false
                            self.subLabel5.isHidden = false
                            self.subLabel6.isHidden = false
                            self.subLabel7.isHidden = false
                            self.subLabel8.isHidden = false
                            self.IDLabel.isHidden = false
                            self.NameLabel.isHidden = false
                            self.startTimeLabel.isHidden = false
                            self.EndTimeLabel.isHidden = false
                            self.roomLabel.isHidden = false
                            self.seatNumberLabel.isHidden = false
                            self.extendedNumberLabel.isHidden = false
                            self.stateLabel.isHidden = false
                            self.mainView1.isHidden = false
                            self.mainView2.isHidden = false
                            self.mainView3.isHidden = false
                            self.mainView4.isHidden = false
                            self.subView1.isHidden = false
                            self.subView2.isHidden = false
                            self.subView3.isHidden = false
                            self.subView4.isHidden = false
                            self.emptyLabel.isHidden = true
                            
                            if self.stateLabel.text != "N"
                            {
                                self.alertButton.isHidden = false
                            }
                            else
                            {
                                self.alertButton.isHidden = true
                            }
                        }
                        else
                        {
                            print("예약 정보 없음")
                            self.EndTimeLabel.isHidden = true
                            
                            self.emptyLabel.isHidden = false
                            self.subLabel1.isHidden = true
                            self.subLabel2.isHidden = true
                            self.subLabel3.isHidden = true
                            self.subLabel4.isHidden = true
                            self.subLabel5.isHidden = true
                            self.subLabel6.isHidden = true
                            self.subLabel7.isHidden = true
                            self.subLabel8.isHidden = true
                            self.IDLabel.isHidden = true
                            self.NameLabel.isHidden = true
                            self.startTimeLabel.isHidden = true
                            self.roomLabel.isHidden = true
                            self.seatNumberLabel.isHidden = true
                            self.extendedNumberLabel.isHidden = true
                            self.stateLabel.isHidden = true
                            self.alertButton.isHidden = true
                            self.mainView1.isHidden = true
                            self.mainView2.isHidden = true
                            self.mainView3.isHidden = true
                            self.mainView4.isHidden = true
                            self.subView1.isHidden = true
                            self.subView2.isHidden = true
                            self.subView3.isHidden = true
                            self.subView4.isHidden = true
                            
                            
                        }
                        
                    } catch let error {
                        print("Error: \(error)")
                    }
                    self.view.endEditing(true)
                    break
                }
                else{
                   
                }
            }
        })
    }



    @IBAction func alertAction(_ sender: Any) {

        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)

        let informantAction: UIAlertAction = UIAlertAction(title: "반납 30분 전 알림", style: UIAlertAction.Style.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            let dateFormatter = DateFormatter()
            var EndtimeText = self.EndTimeLabel.text
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name:  "KST") as TimeZone? //시간 기준 한국으로 변경
            let EndtimeDate = dateFormatter.date(from:EndtimeText!)

            let before30 = EndtimeDate! - 10020
            print(before30)
            var components1 = self.calendar.dateComponents([.year, .month, .day, .hour, .minute],from: before30)
            print(components1)

            let content = UNMutableNotificationContent()
            content.title = "세종대 학술정보원"
            content.body = "좌석 반납 시간 30분 전입니다!"
            content.sound = UNNotificationSound.default

            let trigger = UNCalendarNotificationTrigger(dateMatching: components1, repeats: false)
            let request = UNNotificationRequest(identifier: "testIdentfier", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("취소처리")
        })

        alert.addAction(cancelAction)
        alert.addAction(informantAction)

        self.present(alert, animated: true, completion: nil)
    }

}
