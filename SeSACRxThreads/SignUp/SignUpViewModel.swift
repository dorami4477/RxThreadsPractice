//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailText:ControlProperty<String?> 
        let tap:ControlEvent<Void> 
    }
    
    struct Output {
        let vaild:Observable<Bool>
        let tap:ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let vaild = input.emailText
            .orEmpty
            .map { $0.count > 10 }
        
        return Output(vaild: vaild, tap: input.tap)
    }
}
