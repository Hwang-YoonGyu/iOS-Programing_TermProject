//
//  DbFile.swift
//  ch12-1771293-firebase
//
//  Created by 황윤규 on 2022/05/23.
//

import Foundation

//class DbFile: Database {
//    func saveChange(labtop: Labtop, action: DbAction){
//            // 파일 이름을 만든다 yyyy-mm-dd hh:mm:ss.archive
//        let fileName = labtop.code + ".archive"
//            if action == .Delete{
//                // 파일자체를 지운다
//                if let _ = try? FileManager.default.removeItem(at: dbDir.appendingPathComponent(fileName)){
//                    if let parentNotification = parentNotification{
//                        parentNotification(labtop, action) // planGroup에게도 삭제 사실을 알린다
//                    }
//                }
//                return
//            }
//            // 아카이빙을 한다
//            let archivedLabtop = try? NSKeyedArchiver.archivedData(withRootObject: labtop, requiringSecureCoding: false)
//            // 파일이 이미 존재하면 overwrite, 없으면 생성한다
//            if let _ = try? archivedLabtop?.write(to: dbDir.appendingPathComponent(fileName)){
//                if let parentNotification = parentNotification{
//                    parentNotification(labtop, action) // planGroup에게도 삽입 또는 수정 사실을 알린다
//                }
//            }
//        }
//
//    
//
//    var dbDir: URL
//    var parentNotification: ((Labtop?, DbAction?) -> Void)?       // PlanGroup에서 설정
//    
//    required init(parentNotification: ((Labtop?, DbAction?) -> Void)?) {
//        self.parentNotification = parentNotification
//        dbDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
//    
//    func queryLabtop(rentUserName : String) {
//            
//            // 디렉토리의 모든 파일 목록을 읽어 온다. fileList는 단순히 파일이름들의 배열이다.
//            guard var fileList = try? FileManager.default.contentsOfDirectory(atPath: dbDir.path) else{ return }
//            // 파일 이름으로 정렬한다
//            fileList.sort(by: {$0 < $1})
//            
//            for i in 0..<fileList.count{
//                guard let archived = try? Data(contentsOf: dbDir.appendingPathComponent(fileList[i])) else{ continue }
//                guard let labtop = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived) as? Labtop else{ continue }
//                
//                if let parentNotification = parentNotification{
//                    parentNotification(labtop, .Add) // 부모에게 알림
//                }
//            }
//        }
//
//
//    
//}
