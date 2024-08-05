//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    struct Input {
        let text:ControlProperty<String?>
        let tap:ControlEvent<Void>
    }
    
    struct Output {
        let vaildText:Observable<String>
        let tap:ControlEvent<Void>
        let vaild:Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let vaildText = Observable.just("8자 이상입력해주세요.")
        let valid = input.text
            .orEmpty
            .map { $0.count > 7 }
            .share()
        
        return Output(vaildText: vaildText, tap: input.tap, vaild: valid)
    }
}
