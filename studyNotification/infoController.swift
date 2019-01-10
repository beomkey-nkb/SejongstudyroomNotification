//
//  infoController.swift
//  studyNotification
//
//  Created by 남기범 on 10/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit

//테이블 뷰 구현

class infoController: UITableViewController {
    
    override var preferredStatusBarStyle:UIStatusBarStyle {
        return UIStatusBarStyle.lightContent //상태표시줄 색상 흰색
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //커스텀 테이블뷰를 구현하기 위한 수단
        //새로운 클래스를 만들어서 연결함
        let cellNib  = UINib.init(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")//TableViewCell.xib에 있는 cell의 id와 같아야함
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell에 내용을 집어넣기 위해 꼭 필요한 함수
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell //뒷 부분은 셀을 커스텀할 때 설정해줘야함.
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //cell 높이 //꼭 해줘야함. 안해주면 내용물 안나옴
        return 80.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        //섹션 개수
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell 개수
        return 3
    }

}
