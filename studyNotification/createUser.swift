//
//  createUser.swift
//  studyNotification
//
//  Created by 남기범 on 02/01/2019.
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


class createUser: UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var studyNumber: UITextField!
    var FIRDatabase: DatabaseReference!
    var checkNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase = Database.database().reference()
    }
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        //키보드를 사라지게 해줌
    }
    
    
    //회원가입
    @IBAction func createAccount(_ sender: Any) {
        var Email = emailField.text!
        var password = passwordField.text!
        
        //학번 중복 검사 실행했는지 확인하기
        if checkNumber == 0 {
            let alertController = UIAlertController(title: "학번검사를 하지 않았습니다.",message: "학번 중복 검사를 해주세요!", preferredStyle: UIAlertController.Style.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let cancelButton = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelButton)
            
            self.present(alertController,animated: true,completion: nil)
            
            return
        }//이메일 공백확인
        else if Email == "" {
            let alertController = UIAlertController(title: "이메일을 입력하지 않았습니다.",message: "이메일을 입력 해주세요!", preferredStyle: UIAlertController.Style.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let cancelButton = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelButton)
            
            self.present(alertController,animated: true,completion: nil)
            
            return
        }//비밀번호 공백확인
        else if password == "" {
            let alertController = UIAlertController(title: "비밀번호를 입력하지 않았습니다.",message: "비밀번호를 입력 해주세요!", preferredStyle: UIAlertController.Style.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let cancelButton = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelButton)
            
            self.present(alertController,animated: true,completion: nil)
            
            return
        }
        
        //유저 생성
        Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!
            
        ) { (user, error) in
            
            if user !=  nil{
                
                print("register success")
                let usercurrent = Auth.auth().currentUser
                //데이터베이스 저장
                self.FIRDatabase.child(usercurrent!.uid).setValue([
                    "userEmail": self.emailField.text!,
                    "studyNumber": self.studyNumber.text!
                    ])
                //로그인
                Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                    
                    if user != nil{
                        print("login success")
                        self.performSegue(withIdentifier: "mainView", sender: self)
                    }
                    else{
                        print("login fail")
                        return
                    }
                    
                }
            }
                
            else{
                let alertController = UIAlertController(title: "이미 가입된 이메일 입니다.",message: "다른 이메일로 가입해주세요!", preferredStyle: UIAlertController.Style.alert)
                
                //UIAlertActionStye.destructive 지정 글꼴 색상 변경
                let cancelButton = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
                
                alertController.addAction(cancelButton)
                
                self.present(alertController,animated: true,completion: nil)
                
                
                print("register failed")
                return
                
            }
            
        }
    }
    
    //학번 검사
    @IBAction func sameNumber(_ sender: Any) {
        self.FIRDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value
            let numberStudy = self.studyNumber.text!
            print(values)
            
            let dic = values as! [String: [String:Any]]
            
            for index in dic{
                
                if (index.value["studyNumber"] as! String == "\(numberStudy)" || numberStudy == ""){
                    
                    print("가입 불가")
                    let alertController = UIAlertController(title: "학번 중복 검사",message: "이미 가입된 학번이거나 학번을 입력하지 않았습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    //UIAlertActionStye.destructive 지정 글꼴 색상 변경
                    let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                    
                    alertController.addAction(cancelButton)
                    
                    self.present(alertController,animated: true,completion: nil)
                    self.checkNumber = 0
                    return
                }
                else{
                    print("가입 가능")
                    self.checkNumber = 1
                }
            }
            let alertController = UIAlertController(title: "학번 중복 검사",message: "가입 가능한 학번입니다.", preferredStyle: UIAlertController.Style.alert)
            
            //UIAlertActionStye.destructive 지정 글꼴 색상 변경
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertController.addAction(cancelButton)
            
            self.present(alertController,animated: true,completion: nil)
        })
    }
    
    @IBAction func backbutton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
