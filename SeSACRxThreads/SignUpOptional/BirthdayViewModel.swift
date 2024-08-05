//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let age: PublishRelay<Int>
        let date: ControlProperty<Date>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let year: BehaviorSubject<String>
        let month: BehaviorSubject<String>
        let day: BehaviorSubject<String>
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let year = BehaviorSubject(value: "2024년")
        let month = BehaviorSubject(value: "8월")
        let day = BehaviorSubject(value: "2일")
        
        let validation = input.age
            .map { $0 >= 170000 }
            .share()
        
        
        input.date
            .bind(with: self) { owner, date in
                let date = Calendar.current.dateComponents([.day, .month, .year], from: date)
                year.on(.next("\(date.year!)년"))
                month.on(.next("\(date.month!)월"))
                day.on(.next("\(date.day!)월"))
                
                let month = String(format: "%02d", date.month!)
                let day = String(format: "%02d", date.day!)
                let birthdayString =  "\(date.year!)\(month)\(day)"
                
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "yyyyMMdd"
                let today = myFormatter.string(from: Date())
                let ageInt = Int(today)! - Int(birthdayString)!
                print(ageInt)
                input.age.accept(ageInt)
            }
            .disposed(by: disposeBag)
        
        return Output(year: year, month: month, day: day, validation: validation, tap: input.tap)
    }
}
