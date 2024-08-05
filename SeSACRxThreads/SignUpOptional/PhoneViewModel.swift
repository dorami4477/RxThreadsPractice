//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let phoneText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumber: Observable<String>
        let discription: PublishSubject<String>
        let vaildation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let phoneNumber = Observable.just("010")
        let discription = PublishSubject<String>()
        
        input.phoneText
            .orEmpty
            .map { Int($0) == nil }
            .bind(onNext: { value in
                if value { discription.onNext("숫자만 입력하세요.") }
            })
            .disposed(by: disposeBag)
        
        input.phoneText
            .orEmpty
            .map { $0.count < 10 }
            .bind(onNext: { value in
                if value { discription.onNext("10자리 이상 입력하세요.") }
            })
            .disposed(by: disposeBag)
        
        let vaild = input.phoneText
            .orEmpty
            .map { $0.count >= 10 && Int($0) != nil }
            .share()
        
        vaild
            .bind(onNext: { value in
                if value { discription.onNext("") }
            })
            .disposed(by: disposeBag)
        
        
        return Output(phoneNumber: phoneNumber, discription: discription, vaildation: vaild, tap: input.tap)
    }
}
