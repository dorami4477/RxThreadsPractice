//
//  MovieViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    let disposeBag = DisposeBag()
    //let movieList = ["테스트1", "테스트2", "테스트3"]
    var recentList:[String] = []
    
    struct Input {
       // let selectItem:ControlEvent<String>
        let recentText: PublishSubject<String>
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let movieList:Observable<[dailyBoxOfficeList]>
        let recentList:PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recentList = PublishSubject<[String]>()
        let movieList = PublishSubject<[dailyBoxOfficeList]>()
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let date = Int($0) else {
                    return 20240806
                }
                return date
            }
            .map { "\($0)" }
            .flatMap { value in
                NetworkManager.shared.callRequest(date: value)
            }
            .subscribe(with: self) { owner, movie in
                movieList.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print(error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

            
        return Output(movieList: movieList, recentList: recentList)
    }
}
