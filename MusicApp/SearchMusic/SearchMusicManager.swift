//
//  SearchMusicManager.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/02/21.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case dataError
    case parseError
    case urlError
}

final class SearchMusicManager {
    
    private init() {}
    static let shared = SearchMusicManager()
    
    func fetchMusic(searchTerm: String) async -> Result<[Music], NetworkError> {
        
        let urlString = SearchMusicAPI.urlString(term: searchTerm)
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return .failure(.urlError) }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let musics = self.parseJson(data) {
                return .success(musics)
            } else {
                return .failure(.parseError)
            }
      } catch {
            return .failure(.networkError)
        }
    }
    
    func parseJson(_ musicData: Data) -> [Music]? {
        do {
            let musicdata = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicdata.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    
}
