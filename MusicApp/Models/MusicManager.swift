//
//  MusicManager.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import UIKit
import CoreData

// MARK: - 데이터 관리 모델
final class MusicManager {
    
    static let shared = MusicManager()
    
    private init() {
        fetchMusicSavedArraysFromCoreData {
            print("CoreDataSetting Done")
        }
    }
    
    private let networkManager = SearchMusicManager.shared
    private let coredataManger = CoreDataManager.shared
    
    private var musicArrays: [Music] = []
    private var musicSavedArrays: [MusicSaved] = []
    
    func getMusicArraysFromAPI() -> [Music] {
        checkWhetherSaved()
        return musicArrays
    }
    
    func getMusicSavedArraysFromCoreData() -> [MusicSaved] {
        return musicSavedArrays
    }
    
    // MARK: - API 통신
    // API 검색하기

    func fetchMusicArraysFromAPI(withTerm searhTerm: String) async {
 
        let result = await networkManager.fetchMusic(searchTerm:searhTerm)
        
        switch result {
        case .success(let success):
            self.musicArrays = success
        case .failure(let failure):
            print(failure)
        }
        self.checkWhetherSaved()
    }
    
    // MARK: - CoreData
    // Read
    private func fetchMusicSavedArraysFromCoreData(completion: () -> Void) {
        musicSavedArrays = coredataManger.getMusicSavedArrayFromCoreData()
        completion()
    }
    
    // Created
    func saveMusicDataToCoreData(with music: Music, message: String?, completion: @escaping () -> Void) {
        coredataManger.saveMusic(with: music, message: message) {
            self.fetchMusicSavedArraysFromCoreData {
                completion()
            }
        }
    }
    
    // Delete (Music 타입을 가지고 데이터 지우기) -> 저장되어 있는지 확인하고 지움
    func deleteMusicFromCoreData(with musicSaved: Music, completion: @escaping () -> Void) {
        let musicSaved = musicSavedArrays.filter { $0.songName == musicSaved.songName && $0.artistName == musicSaved.artistName
        }
        
        if let targetMusicSaved = musicSaved.first {
            self.deleteMusicSavedFromCoreData(with: targetMusicSaved) {
                print("Delete Music Done")
                completion()
            }
        } else {
            print("No Match Data")
            completion()
        }
    }
    
    // Delete (MusicSaved 타입을 가지고 데이터 지우기)
    func deleteMusicSavedFromCoreData(with musicSaved: MusicSaved, completion: @escaping () -> Void) {
        coredataManger.deleteMusic(with: musicSaved) {
            self.fetchMusicSavedArraysFromCoreData {
                completion()
            }
        }
    }
    
    // Update coreData
    func updateMusicSavedToCoreData(with musicSaved: MusicSaved, completion: @escaping () -> Void) {
        coredataManger.updateMusic(with: musicSaved) {
            self.fetchMusicSavedArraysFromCoreData {
                completion()
            }
        }
    }
    
    // 이미 저장된 데이터들인지 확인
    func checkWhetherSaved() {
        musicArrays.forEach { music in
            if musicSavedArrays.contains(where: {
                $0.songName == music.songName && $0.artistName == music.artistName
            }) {
                music.isSaved = true
            } else {
                music.isSaved = false
            }
        }
    }
    
}
