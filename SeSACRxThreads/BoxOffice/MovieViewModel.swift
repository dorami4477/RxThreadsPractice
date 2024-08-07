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
    let movieList = ["테스트1", "테스트2", "테스트3"]
    var recentList:[String] = []
    
    struct Input {
       // let selectItem:ControlEvent<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let movieList:BehaviorSubject<[String]>
        let recentList:PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recentList = PublishSubject<[String]>()
        let movieList = BehaviorSubject(value: movieList)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        return Output(movieList: movieList, recentList: recentList)
    }
}
