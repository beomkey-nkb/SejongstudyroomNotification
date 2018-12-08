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
    
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var ViewDID: ViewCustom!
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
    
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let components = self.calendar.dateComponents([.year, .month, .day], from: self.now)
        //현재 정보에서 원하는 정보만 추출(년도,달,일)
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
        //int로 강제 형변환
        print(self.year)
        print(self.month)
        print(self.day)
        
        //검색버튼 누르기 전에 숨기기
        ViewDID.isHidden = true
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
        
        
        
        // Do any additional setup after loading the view, typically from a nib
    }
    
    @IBAction func post(_ sender: Any) {
        let txtSeat = userID.text!
        
        if txtSeat != "" {
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
                    
                    IDLabel.text = arrInformation[arrInformation.count-1].ID
                    NameLabel.text = arrInformation[arrInformation.count-1].name
                    startTimeLabel.text = arrInformation[arrInformation.count-1].startTime
                    EndTimeLabel.text = arrInformation[arrInformation.count-1].endTime
                    roomLabel.text = arrInformation[arrInformation.count-1].room
                    seatNumberLabel.text = arrInformation[arrInformation.count-1].seatNumber
                    extendedNumberLabel.text = arrInformation[arrInformation.count-1].extendedNumber
                    stateLabel.text = arrInformation[arrInformation.count-1].state
                
                
                    ViewDID.isHidden = false
                    subLabel1.isHidden = false
                    subLabel2.isHidden = false
                    subLabel3.isHidden = false
                    subLabel4.isHidden = false
                    subLabel5.isHidden = false
                    subLabel6.isHidden = false
                    subLabel7.isHidden = false
                    subLabel8.isHidden = false
                    IDLabel.isHidden = false
                    NameLabel.isHidden = false
                    startTimeLabel.isHidden = false
                    EndTimeLabel.isHidden = false
                    roomLabel.isHidden = false
                    seatNumberLabel.isHidden = false
                    extendedNumberLabel.isHidden = false
                    stateLabel.isHidden = false
                    
                    if stateLabel.text != "N"
                    {
                        alertButton.isHidden = false
                    }
                    else
                    {
                        alertButton.isHidden = true
                    }
                }
                else
                {
                    print("예약 정보 없음")
                    EndTimeLabel.text = "예약 정보 없음."
                    EndTimeLabel.isHidden = false
                    ViewDID.isHidden = false
                    
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
                    roomLabel.isHidden = true
                    seatNumberLabel.isHidden = true
                    extendedNumberLabel.isHidden = true
                    stateLabel.isHidden = true
                    alertButton.isHidden = true
                }
                
            } catch let error {
                print("Error: \(error)")
            }
        }
        else
        {
            let alertController = UIAlertController(title: "학번을 입력하지 않았습니다.",message: "학번을 입력해주세요!", preferredStyle: UIAlertController.Style.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let cancelButton = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelButton)
            
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    
    
    @IBAction func alertAction(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)
        
        let informantAction: UIAlertAction = UIAlertAction(title: "반납 30분 전 알림", style: UIAlertAction.Style.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            let dateFormatter = DateFormatter()
            var EndtimeText = self.EndTimeLabel.text
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name:  "UTC") as TimeZone?
            let EndtimeDate = dateFormatter.date(from:EndtimeText!)
            
            let before30 = EndtimeDate! - 1800
            
            print(before30)
            print(Double(before30.timeIntervalSince(Date())))
            let timeInter = Double(before30.timeIntervalSince(Date()))
            let content = UNMutableNotificationContent()
            content.title = "세종대 학술정보원"
            content.body = "좌석 반납 시간 30분 전입니다!"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInter, repeats: false)
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


