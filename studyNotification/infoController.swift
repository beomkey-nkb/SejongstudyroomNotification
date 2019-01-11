//
//  infoController.swift
//  studyNotification
//
//  Created by 남기범 on 10/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
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
import MBCircularProgressBar

var InfoUsed = [String]()
var InfoRoom = ["A열람실","B열람실","C열람실","D열람실A","D열람실B","3층열람실A","3층열람실B"]
var InfoAll = [188,188,208,156,174,236,160]

//테이블 뷰 구현

class infoController: UITableViewController {
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //33~58 html 파싱
        InfoUsed.removeAll()
        let InfoencodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)//euc-kr 인코딩을 위한 코드
        let InfomainURL = "http://210.107.226.14/seat/domian5.asp"
        
        guard let Infomain = URL(string: InfomainURL) else {
            print("Error: \(InfomainURL) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let lolMain = try String(contentsOf: Infomain, encoding: String.Encoding(rawValue: InfoencodingEUCKR))
            //url을 string으로 인코딩
            let Infoconfirm:Document = try SwiftSoup.parse(lolMain)
            
            for index in 3..<10{
                let Infolink: Element = try Infoconfirm.select("body > center > form > table:nth-child(3) > tbody > tr:nth-child(\(index)) > td:nth-child(4) > font").first()!
                
                let exam = try Infolink.text()
            
                InfoUsed.append(exam)
            }
            print(InfoUsed)
        } catch let error {
            print("error = \(error)")
        }
        
        //커스텀 테이블뷰를 구현하기 위한 수단
        //새로운 클래스를 만들어서 연결함
        let cellNib  = UINib.init(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
        //TableViewCell.xib에 있는 cell의 id와 같아야함
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell에 내용을 집어넣기 위해 꼭 필요한 함수
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        //뒷 부분은 셀을 커스텀할 때 설정해줘야함.
        cell.Room.text = InfoRoom[indexPath.row]
        cell.allSeat.text = "\(InfoAll[indexPath.row])"
        cell.extraSeat.text = "\(InfoAll[indexPath.row]-Int(InfoUsed[indexPath.row])!)"
        
        let percent = (Double(Double(InfoUsed[indexPath.row])!/Double(InfoAll[indexPath.row]))*100).rounded(toPlaces: 2)

        cell.pie.value = CGFloat(percent)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //cell 높이 //꼭 해줘야함. 안해주면 내용물 안나옴
        return 160.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        //섹션 개수
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell 개수
        return 7
    }

}
extension Double {
    //소수점 반올림을 위한 설정
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
