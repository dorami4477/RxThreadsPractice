//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/8/24.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invaildURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest(date: String) -> Observable<Movie> {
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=a7400b55a47314dc4b5f52a5db0d6efc&targetDt=\(date)"
        
        let result = Observable<Movie>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(NetworkError.invaildURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    observer.onError(NetworkError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("디코딩 실패")
                    observer.onError(NetworkError.statusError)
                }
            }.resume()
            return Disposables.create()
        }

        return result
    }
}
