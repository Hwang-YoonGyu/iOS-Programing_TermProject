//
//  DetailViewController.swift
//  iOS-Project-1771293
//
//  Created by 황윤규 on 2022/05/26.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
class DetailViewController : UIViewController {
    var mvc : MainViewController!
    var labtopGroup: LabtopGroup!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var codeText: UILabel!
    @IBOutlet weak var rentDateText: UILabel!
    @IBOutlet weak var returnDateText: UILabel!
    @IBOutlet weak var userIdText: UILabel!
    @IBOutlet weak var userNameBtn: UILabel!
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func rentBtn(_ sender: UIButton) {
        let labtop = Labtop(code: "", rentUserName: "", rentUserPhone: "", name: "", status: "")
        labtop.code = self.code
        labtop.name = self.name
        labtop.rentUserName = self.userName
        labtop.status = "대여중"
        labtop.rentDate = Date(timeIntervalSinceNow: 0)
        labtop.returnDate = Date(timeIntervalSinceNow: 86400*30)
        saveChangeDelegate?(labtop)
        if (isRented == "0") { //MainViewController로 부터 넘겨받은 유저가 대여를 하지 않은 유저라면 대여 승낙
            labtopGroup.saveChange(labtop: labtop,userName: self.userName, userId: self.userId, action: DbAction.Modify)
            let queryReference = Firestore.firestore().collection("User").document(self.email).setData(["isRented" : "1"], merge: true)
            mvc?.changeIsRented(data: "1") //MainViewController에 접근해서 isRented를 1(참)으로 바꿔줌
            self.navigationController?.popViewController(animated: true) //MainViewController로 돌아감

        }
        else if (isRented == "1") { //MainViewController로 부터 넘겨받은 유저가 이미 대여를 한 유저라면 대여 거부
            let alert = UIAlertController(title:"대여 실패",
                message: "이미 대여하신 기자재가 존재하여 대여가 불가합니다.",
                preferredStyle: UIAlertController.Style.alert)
            //2. 확인 버튼 만들기
            let cancle = UIAlertAction(title: "확인", style: .default, handler: {
                action in
                self.navigationController?.popViewController(animated: true) //MainViewController로 돌아감
            })
            alert.addAction(cancle)
            present(alert,animated: true,completion: nil)
        }
    }
    var saveChangeDelegate: ((Labtop)-> Void)?
    // phone -> id
    var name: String = ""
    var code: String = ""
    var email: String = ""
    var rentDate: String = ""
    var returnDate: String = ""
    var userId: String = ""
    var userName: String = ""
    var isRented: String = ""

    //3. 확인 버튼을 경고창에 추가하기
    //4. 경고창 보이기
    
    var labtop: Labtop!
    override func viewDidLoad() {
        nameText.text = name
        codeText.text = code
        rentDateText.text = rentDate
        returnDateText.text = returnDate
        userIdText.text = userId
        userNameBtn.text = userName

    }
    

}
