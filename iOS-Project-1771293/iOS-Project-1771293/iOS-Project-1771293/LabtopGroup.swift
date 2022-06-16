//
//  PlanGroup.swift
//  ch09-1771293-tableView
//
//  Created by 황윤규 on 2022/04/27.
//

import Foundation
import Firebase
class LabtopGroup: NSObject{
    var labtops = [Labtop]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var fromDate, toDate: Date?     // queryPlan 함수에서 주어진다.
    var database: Database!
    var parentNotification: ((Labtop?, DbAction?) -> Void)?
    init(parentNotification: ((Labtop?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        //database = DbFile(parentNotification: receivingNotification) // 데이터베이스 생성
        database = DbFirebase(parentNotification: receivingNotification) // 데이터베이스 생성

    }
    func receivingNotification(labtop: Labtop?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let labtop = labtop{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addLabtop(labtop: labtop)
                case .Modify: modifyLabtop(modifiedLabtop: labtop)
                case .Delete: removeLabtop(removedLabtop: labtop)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(labtop, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}
extension LabtopGroup{
    
    func queryData(rentUserName : String){ //전체를 쿼리
        labtops.removeAll()
        database.queryLabtop(rentUserName: rentUserName)
    }
    func queryMyData(rentUserName : String) { //대여자 이름이 자신의 이름으로 된 것만 쿼리
        labtops.removeAll()
        database.queryMyLabtop(rentUserName: rentUserName)
    }
    func saveChange(labtop: Labtop, userName: String, userId: String, action: DbAction){

        database.saveChange(labtop: labtop, userName: userName, userId: userId, action: action)
    }
}
extension LabtopGroup{
    func getRentedLabtop(rentUserName: String? = nil) -> [Labtop] {
        var labtopForRentUserName = [Labtop]()

        for labtop in labtops{
            if labtop.rentUserName == rentUserName {
                labtopForRentUserName.append(labtop)
            }
        }
        
        return labtopForRentUserName
    }
    func getLabtops() -> [Labtop] { //현재 [Labtop]을 전부 돌려줌
        return labtops
    }
    func detailLabtop(code: String?) -> Labtop { //노트북의 고유키인 code가 일치하는 노트북의 정보를 Labtop으로 돌려줌
        var labtopDetailTemp = Labtop(code: "", rentUserName: "", rentUserPhone: "", name: "", status: "")
        
        for labtop in labtops{
            if labtop.code == code {
                labtopDetailTemp.code = labtop.code
                labtopDetailTemp.name = labtop.name
                labtopDetailTemp.rentUserName = labtop.rentUserName
                labtopDetailTemp.rentUserPhone = labtop.rentUserName
                labtopDetailTemp.status = labtop.status
            }
        }
        
        return labtopDetailTemp
    }
}
extension LabtopGroup{
    
    private func count() -> Int{ return labtops.count } // 사이즈 리턴
    
//    func isRent(rentUserName: String) -> Bool{
//        if let from = fromDate, let to = toDate{
//            return (date >= from && date <= to) ? true: false
//        }
//        return false
//    }
    
    private func find(_ key: String) -> Int?{ //찾는 노트북의 인덱스를 리턴
        for i in 0..<labtops.count{
            if key == labtops[i].code{
                return i
            }
        }
        return nil
    }
}
extension LabtopGroup{
    private func addLabtop(labtop: Labtop){ labtops.append(labtop) } //구현되어있으나 사용하지는 않음
    private func modifyLabtop(modifiedLabtop: Labtop){
        if let index = find(modifiedLabtop.code){
            labtops[index] = modifiedLabtop
        }
    }
    private func removeLabtop(removedLabtop: Labtop){
        if let index = find(removedLabtop.code){
            labtops.remove(at: index)
        }
    }
    func changeLabtop(from: Labtop, to: Labtop){
        if let fromIndex = find(from.code), let toIndex = find(to.code) {
            labtops[fromIndex] = to
            labtops[toIndex] = from
        }
    }
}

