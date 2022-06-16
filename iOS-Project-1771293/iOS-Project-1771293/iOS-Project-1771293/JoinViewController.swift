//
//  JoinViewController.swift
//  iOS-Project-1771293
//
//  Created by 황윤규 on 2022/05/23.
//
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Foundation
import UIKit
class JoinViewController : UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    
    
    let db = Firestore.firestore()
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func joinBtn(_ sender: Any) { //joinBtn을 누를시 회원가입을 실행
        Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { [weak self] authResult, error in
            if authResult != nil { //회원가입에 성공할시 FireStore에 정보를 삽입
                Firestore.firestore().collection("User").document(self!.emailField.text!).setData([
                    "email" : self!.emailField.text!,
                    "password" : self!.passwordField.text!,
                    "name" : self!.nameField.text!,
                    "id" : self!.idField.text!,
                    "phone" : self!.phoneField.text!,
                    "isRented" : "0"
                ])
                let alert = UIAlertController(title:"",message: "회원가입이 완료되었습니다",preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: {
                    action in
                    self!.navigationController?.popViewController(animated: true)
                })
                alert.addAction(ok)
                self?.present(alert,animated: true,completion: nil)
            }
            else { //회원가입 실패시, 알림창을 띄움
                let alert = UIAlertController(title:"에러",message: "알 수 없는 이유로 회원가입을 하지 못했습니다. 잠시후 다시 시도해 주세요",preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: {
                    action in
                    self!.dismiss(animated: true)
                })
                alert.addAction(ok)
                self?.present(alert,animated: true,completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){      self.view.endEditing(true)}
}
