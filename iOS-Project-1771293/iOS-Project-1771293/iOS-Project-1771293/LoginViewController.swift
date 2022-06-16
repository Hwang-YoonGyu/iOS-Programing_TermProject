//
//  ViewController.swift
//  iOS-Project-1771293
//
//  Created by 황윤규 on 2022/05/16.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginViewController: UIViewController{
    
    var id: String = ""
    var name: String = ""
    var isRented: String = ""
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginBtn(_ sender: UIButton) { //로그인시 firebase auth를 통해 회원가입을 실시하고 알림창을 띄움
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
            if authResult != nil {
                print("Login Success@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                let queryReference = Firestore.firestore().collection("User").document(self!.emailField.text!).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        let name = document["name"]! as! String
                        let id = document["id"]! as! String
                        let isRented = document["isRented"] as! String
                        self!.id = id
                        self!.name = name
                        self!.isRented = isRented
                        self!.moveMain()
                    } else {
                        print("Document does not exist")
                    }

                }
            }
            else { //로그인 실패시 알림창을 띄움
                print("Login Fail@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                let alert = UIAlertController(title:"로그인 실패",message: "아이디와 비밀번호를 확인해주세요",preferredStyle: UIAlertController.Style.alert)
                //확인 버튼 만들기
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                self!.present(alert,animated: true,completion: nil)
            }
        }

    }
    func moveMain() { //NavigationViewController를 통해 MainViewController를 push
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                // 뷰 객체 얻어오기 (storyboard ID로 ViewController구분)
        if let mvc = storyboard?.instantiateViewController(identifier: "Main") as? MainViewController {
            mvc.userId = self.id
            mvc.userName = self.name
            mvc.email = self.emailField.text!
            mvc.isRented = self.isRented
            mvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            mvc.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(mvc, animated: true)
        } else {
            return
        }        // 화면 전환 애니메이션 설정
    }
    @IBAction func joinBtn(_ sender: UIButton) { //NavigationViewController를 통해 JoinViewController를 push
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let jvc = storyboard?.instantiateViewController(identifier: "Join") as? JoinViewController {

            jvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            jvc.modalPresentationStyle = .popover
            
            self.navigationController?.pushViewController(jvc, animated: true)
        } else {
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){      self.view.endEditing(true)}
}


