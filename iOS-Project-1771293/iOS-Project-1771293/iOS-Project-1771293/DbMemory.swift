//
//  DbMemory.swift
//  ch09-1771293-tableView
//
//  Created by 황윤규 on 2022/04/27.
//

import Foundation
// Database.swift
enum DbAction{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}
protocol Database{
    // 생성자, 데이터베이스에 변경이 생기면 parentNotification를 호출하여 부모에게 알림
    init(parentNotification: ((Labtop?, DbAction?) -> Void)? )

    // fromDate ~ toDate 사이의 Plan을 읽어 parentNotification를 호출하여 부모에게 알림
    func queryLabtop(rentUserName: String)
    
    func queryMyLabtop(rentUserName: String)

    // 데이터베이스에 plan을 변경하고 parentNotification를 호출하여 부모에게 알림
    func saveChange(labtop: Labtop, userName: String, userId:String ,action: DbAction)
}

class DbMemory: Database {

    private var storage: [Labtop]  // 데이터 저장고

    // storgae내의 데이터변화가 있으면 이 함수를 호출해야 함
    var parentNotification: ((Labtop?, DbAction?) -> Void)?

    // required라는 것은 이 클래스가 Database를 만족하여야 하기 때문임, see Database
    required init(parentNotification: ((Labtop?, DbAction?) -> Void)?) {

        self.parentNotification = parentNotification // nil일 수도 있다

        storage = []
        // 100개의 가상 데이터를 만든다. 현재 기준으로 -50일 +50일 사이에 랜덤하게 만듬

        
    }
}
extension DbMemory{    // DbMemory.swift
    // 이 함수는 fromDate~toDate사이의 플랜을 찾아서 리턴한다.
    // 재미있는 것은 찾아서 전부 한거번에 리턴하는 것이 아니라
    // parentNotification에게 한번에 1개씩 전해준다
    func queryLabtop(rentUserName : String) {

        for i in 0..<storage.count{
            if storage[i].rentUserName == rentUserName {
                if let parentNotification = parentNotification{
                    parentNotification(storage[i], DbAction.Add) // 한개씩 여러번 전달한다
                }
            }
        }
    }
    func queryMyLabtop(rentUserName : String) {

        for i in 0..<storage.count{
            if storage[i].rentUserName == rentUserName {
                if let parentNotification = parentNotification{
                    parentNotification(storage[i], DbAction.Add) // 한개씩 여러번 전달한다
                }
            }
        }
    }
}
extension DbMemory{// DbMemory.swift
    // 주어진 플랜에 대하여 삽입, 수정, 삭제를 storage에서 하고
    // 역시 parentListener를 호출하여 이러한 사실을 알린다.
    func saveChange(labtop: Labtop, userName: String, userId:String, action: DbAction){
        if action == .Add{
            storage.append(labtop)
        }else{
            for i in 0..<storage.count{
                if labtop.code == storage[i].code{
                    if action == .Delete{ storage.remove(at: i) }
                    if action == .Modify{ storage[i] = labtop }
                    break
                }
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(labtop, action)  // 변경된 내역을 알려준다
        }
    }
}


