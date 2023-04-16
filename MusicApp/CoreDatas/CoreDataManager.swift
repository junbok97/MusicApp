//
//  CoreDataManager.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    typealias completionHandler = () -> Void
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = "MusicSaved"
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getMusicSavedArrayFromCoreData() -> [MusicSaved] {
        var savedMusicArray: [MusicSaved] = []
        
        guard let context = context else { return [] }
        
        // 요청서 생성
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        
        // 정렬순서 지정
        // 코어데이터 MusicSaved에 있는 saveDate를 기준으로 내림차순
        let saveDate = NSSortDescriptor(key: "savedDate", ascending: true)
        request.sortDescriptors = [saveDate]
        
        do {
            if let fetchMusicArray = try context.fetch(request) as? [MusicSaved] {
                savedMusicArray = fetchMusicArray
            }
        } catch {
            print("코어데이터 로드 실패")
            print(error.localizedDescription)
        }
        
        return savedMusicArray
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기 Music -> MusicSaved로
    func saveMusic(with music: Music, message: String?, completion: @escaping completionHandler) {
        // 임시 저장소 확인
        if let context = context {
            // 임시조장소에 있는 데이터 형태 파악
            if let enity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                // 임시저장소에 올라갈 객체 생성 NSManagedObject -> MusicSaved
    //            if let musicSaved = MusicSaved(context: context)
                if let musicSaved = NSManagedObject(entity: enity, insertInto: context) as? MusicSaved {
                    
                    // MusicSaved에 데이터 할당
                    musicSaved.songName = music.songName
                    musicSaved.artistName = music.artistName
                    musicSaved.albumName = music.albumName
                    musicSaved.imageUrl = music.imageUrl
                    musicSaved.releaseDate = music.releaseDateString
                    musicSaved.savedDate = Date() // 날짜는 저장하는 순간의 날짜로 생성
                    musicSaved.myMessage = message
                    
    //                appDelegate?.saveContext()
//                    completion()
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                        completion()
                    }
                }
            }
        } else {
            completion()
        }
        
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 -> 삭제)
    func deleteMusic(with music: MusicSaved, completion: @escaping completionHandler) {
        guard let saveDate = music.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            
            // 요청서 생성
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            // 조건 설정
            request.predicate = NSPredicate(format: "savedDate = %@", saveDate as CVarArg)
            
            do {
                // 임시 저장소에서 요청서를 통해 데이터를 가져오고
                if let fetchedMusicArray = try context.fetch(request) as? [MusicSaved] {
                    
                    // 날짜가 같은 데이터는 하나일테니 첫번째 것을 삭제
                    if let targetMusic = fetchedMusicArray.first {
                        context.delete(targetMusic)
//                        appDelegate?.saveContext()
//                        completion()
                        
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
            } catch {
                print("Delete Load Error")
                print(error)
                completion()
            }
        }
    }
    
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 -> 수정)
    func updateMusic(with music: MusicSaved, completion: @escaping completionHandler) {
        guard let savedDate = music.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                if let fetchMusicArray = try context.fetch(request) as? [MusicSaved] {
                    if var targetMusic = fetchMusicArray.first {
                        targetMusic = music
                    }
                    
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("Update Load Error")
                print(error)
                completion()
            }
        }
    }
    
}
