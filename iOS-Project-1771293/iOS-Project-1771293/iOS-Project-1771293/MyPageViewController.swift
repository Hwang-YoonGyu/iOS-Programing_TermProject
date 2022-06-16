//
//  MyPageViewController.swift
//  iOS-Project-1771293
//
//  Created by 황윤규 on 2022/05/29.
//

import Foundation
import UIKit
class MyPageViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var labtopGroup: LabtopGroup!
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    var name: String = "김이박"
    var id: String = ""
    
    
    override func viewDidLoad() {
        nameText.text = name
        idText.text = id
        tableView.dataSource = self
        tableView.delegate = self
        labtopGroup = LabtopGroup(parentNotification: receiveingNotification)
        labtopGroup.queryMyData(rentUserName: self.name)
    }
    
}
extension MyPageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labtopGroup.getLabtops().count
    }
    func receiveingNotification(labtop: Labtop?, action: DbAction?){
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageViewCell")
        let labtop = labtopGroup.getRentedLabtop(rentUserName: name)[indexPath.row]

        if (labtop.code != "") {
            (cell?.contentView.subviews[0] as! UILabel).text = labtop.name
            (cell?.contentView.subviews[1] as! UILabel).text = labtop.code
            (cell?.contentView.subviews[2] as! UILabel).text = labtop.returnDate.toStringDate()
        }
        else {
            (cell?.contentView.subviews[0] as! UILabel).text = ""
            (cell?.contentView.subviews[1] as! UILabel).text = ""
            (cell?.contentView.subviews[2] as! UILabel).text = ""
        }
        return cell!
    }
}
