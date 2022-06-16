//
//  plan.swift
//  ch09-1771293-tableView
//
//  Created by 황윤규 on 2022/04/27.
//

import Foundation
class Labtop: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(rentDate, forKey: "rentDate")
        aCoder.encode(returnDate, forKey: "returnDate")
        aCoder.encode(rentUserName, forKey: "rentUserName")
        aCoder.encode(rentUserPhone, forKey: "rentUserPhone")
        aCoder.encode(name, forKey: "name")

    }
    
    required init?(coder aDecoder: NSCoder) {
        code = aDecoder.decodeObject(forKey: "code") as! String // 내부적으로 String.init가 호출된다
        rentDate = aDecoder.decodeObject(forKey: "rentDate") as! Date
        returnDate = aDecoder.decodeObject(forKey: "returnDate") as! Date
        rentUserName = aDecoder.decodeObject(forKey: "rentUserName") as! String
        rentUserPhone = aDecoder.decodeObject(forKey: "rentUserPhone") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        status = aDecoder.decodeObject(forKey: "status") as! String
        super.init()

    }

    var code: String
    var rentDate: Date
    var returnDate: Date
    var rentUserName : String
    var rentUserPhone : String
    var status: String
    var name: String

    init(code: String, rentUserName: String, rentUserPhone: String, name: String, status: String){
        self.code = code  // 거의 unique한 id를 만들어 낸다.
        self.rentDate = Date(timeIntervalSinceNow: 0)
        self.returnDate = Date(timeIntervalSinceNow: 86400*30)
        self.rentUserName = rentUserName
        self.rentUserPhone = rentUserPhone
        self.name = name
        self.status = status
        super.init()
    }

}
extension Labtop {
    func clone() -> Labtop {

        let nscoder = NSCoder()

        let clonee = Labtop(coder: nscoder)

        clonee!.code = self.code    // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee!.rentDate = Date(timeInterval: 0, since: self.returnDate) // Date는 struct가 아니라 class이기 때문
        clonee!.returnDate = Date(timeInterval: 86400*30, since: self.returnDate)
        clonee!.rentUserName = self.rentUserName    // enum도 struct처럼 복제가 된다
        clonee!.rentUserPhone = self.rentUserPhone
        clonee!.name = self.name
        return clonee!
    }
}

