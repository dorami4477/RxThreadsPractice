//
//  Movie.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/8/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: boxOfficeResult
}

struct boxOfficeResult: Decodable {
    let dailyBoxOfficeList: [dailyBoxOfficeList]
}

struct dailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
