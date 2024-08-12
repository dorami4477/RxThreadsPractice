//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

final class ShoppingListViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    var data = [
        ShoppingList(title: "그립톡 구매하기"),
        ShoppingList(title: "사이다 구메"),
        ShoppingList(title: "양말")
    ]
    var suggestedItem = Observable.just(["아이템1", "아이템2", "아이템3", "아이템4", "아이템5", "아이템6"])
    
    struct Input {
        let tap: ControlEvent<Void>
        let text: ControlProperty<String?>
        let modelSeleted: ControlEvent<ShoppingList>
        let updateItem: PublishSubject<ShoppingList>
        let deleteItem:ControlEvent<IndexPath>
        let recentItemSelected: ControlEvent<String>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let list: BehaviorSubject<[ShoppingList]>
        let modelSeleted: ControlEvent<ShoppingList>
        let suggestedItem: Observable<[String]>
    }
    
    func transform(input: Input) -> Output {
        let list = BehaviorSubject(value: data)
        
        input.tap
            .withLatestFrom(input.text.orEmpty) { void, text in
                return text
               }
            .bind(with: self, onNext: { owner, value in
                let newItem = ShoppingList(title: value)
                owner.data.insert(newItem, at: 0)
                list.onNext(owner.data)
            })
            .disposed(by: disposeBag)
        
        input.updateItem
            .bind(with: self, onNext: { owner, updatedItem in
                if let index = owner.data.firstIndex(where: { $0.id == updatedItem.id }) {
                    owner.data[index] = updatedItem
                    list.onNext(owner.data)
                }
            })
            .disposed(by: disposeBag)
        
        
        input.deleteItem
            .bind(with: self, onNext: { owner, indexPath in
                owner.data.remove(at: indexPath.row)
                list.onNext(owner.data)
            })
            .disposed(by: disposeBag)
        
        input.recentItemSelected
            .subscribe(with: self) { owner, value in
                let newItem = ShoppingList(title: value)
                owner.data.insert(newItem, at: 0)
                list.onNext(owner.data)
            }
           .disposed(by: disposeBag)
        
        return Output(tap: input.tap, list: list, modelSeleted: input.modelSeleted, suggestedItem: suggestedItem)
    }
}
