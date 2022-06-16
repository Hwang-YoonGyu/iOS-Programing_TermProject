//
//  MainViewController.swift
//  iOS-Project-1771293
//
//  Created by 황윤규 on 2022/05/23.
//
import Firebase
import Foundation
import UIKit
class MainViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var userName: String = "김이박"
    var userId : String = "1234567"
    var email: String = ""
    var isRented : String = ""
    var labtopGroup: LabtopGroup!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoText.text = userId + " " + userName

        tableView.dataSource = self
        tableView.delegate = self
        labtopGroup = LabtopGroup(parentNotification: receiveingNotification)
        labtopGroup.queryData(rentUserName: self.userName)
    }
    func receiveingNotification(labtop: Labtop?, action: DbAction?){
        tableView.reloadData()
    }
    @IBAction func gotoDetail(_ sender: UIButton) {
    }
    @IBAction func myPageBtn(_ sender: UIButton) {
        let labtop = labtopGroup.getRentedLabtop(rentUserName: userName)
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        
                            // 뷰 객체 얻어오기 (storyboard ID로 ViewController구분)
        if let mpvc = storyboard?.instantiateViewController(identifier: "MyPage") as? MyPageViewController {
            mpvc.id = self.userId
            mpvc.name = self.userName
            self.navigationController?.pushViewController(mpvc, animated: true)
        
        } else {
            return
        }
    }
    func changeIsRented(data: String) { // DetailViewController에서 실행될 함수
        self.isRented = data
    }
    func gotoDetailMethod(code: String) { //누른 버튼에 해당하는 노트북정보를 쿼리하여 DetailViewController로 넘겨줌
        let labtop = labtopGroup.detailLabtop(code: code)
        let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
        
                            // 뷰 객체 얻어오기 (storyboard ID로 ViewController구분)
        if let dvc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            dvc.code = labtop.code
            dvc.name = labtop.name
            dvc.rentDate = labtop.rentDate.toStringDate()
            dvc.returnDate = labtop.returnDate.toStringDate()
            dvc.userName = self.userName
            dvc.userId = self.userId
            dvc.email = self.email
            dvc.isRented = self.isRented
            dvc.labtopGroup = self.labtopGroup
            dvc.mvc = self
            print("isRented is "+self.isRented)
            self.navigationController?.pushViewController(dvc, animated: true)
            //self.present(dvc, animated: true)
        
        } else {
            return
        }
    }
}
extension MainViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labtopGroup.getLabtops().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabtopTableViewCell")
        let labtop = labtopGroup.getLabtops()[indexPath.row]
        (cell?.contentView.subviews[0] as! UILabel).text = labtop.name
        (cell?.contentView.subviews[1] as! UILabel).text = labtop.code

        if (labtop.status == "대여중"){ //현재 해당 노트북이 대여중일 때는 버튼을 비활성화 시킴
            (cell?.contentView.subviews[2] as! UIButton).isEnabled = false;
            (cell?.contentView.subviews[2] as! UIButton).setTitle("불가", for: .normal)

        }
        else {
            (cell?.contentView.subviews[2] as! UIButton).addAction { //Action을 유동적으로 달음
                //self.gotoDetailMethod(code: labtop.code)
                let labtop = self.labtopGroup.detailLabtop(code: labtop.code)
                let storyboard: UIStoryboard? = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                                    // 뷰 객체 얻어오기 (storyboard ID로 ViewController구분)
                if let dvc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
                    dvc.code = labtop.code
                    dvc.name = labtop.name
                    dvc.rentDate = labtop.rentDate.toStringDate()
                    dvc.returnDate = labtop.returnDate.toStringDate()
                    dvc.userName = self.userName
                    dvc.userId = self.userId
                    dvc.email = self.email
                    dvc.isRented = self.isRented
                    dvc.labtopGroup = self.labtopGroup
                    dvc.mvc = self
                    print("isRented is "+self.isRented)
                    self.navigationController?.pushViewController(dvc, animated: true)
                    //self.present(dvc, animated: true)
                
                } else {
                    return
                }
            }
        }
        print(labtop.code + " " + labtop.status)
        return cell!
    }
}
extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: .touchUpInside)
    }
}
