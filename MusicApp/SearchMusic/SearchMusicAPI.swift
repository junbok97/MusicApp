//
//  SearchMusicAPI.swift
//  NewMusicApp
//
//  Created by 이준복 on 2023/03/19.
//

import UIKit

struct SearchMusicAPI {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
    static let countryParam = "country=KR"
    
    static func urlString(term: String) -> String {
        return "\(SearchMusicAPI.requestUrl)\(SearchMusicAPI.countryParam)&\(SearchMusicAPI.mediaParam)&term=\(term)"
    }
}
