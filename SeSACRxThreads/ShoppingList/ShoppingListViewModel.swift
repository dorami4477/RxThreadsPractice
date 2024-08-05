//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
        let text: ControlProperty<String?>
        let modelSeleted: ControlEvent<ShoppingList>
        let updateItem: PublishSubject<ShoppingList>
        let deleteItem:ControlEvent<IndexPath>
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let list: BehaviorSubject<[ShoppingList]>
        let modelSeleted: ControlEvent<ShoppingList>
    }
    
    func transform(input: Input) -> Output {
        var data = [
            ShoppingList(title: "그립톡 구매하기"),
            ShoppingList(title: "사이다 구메"),
            ShoppingList(title: "양말")
        ]
        lazy var list = BehaviorSubject(value: data)
        
        input.tap
            .withLatestFrom(input.text.orEmpty) { void, text in
                return text
               }
            .bind(onNext: { value in
                let newItem = ShoppingList(title: value)
                data.insert(newItem, at: 0)
                list.onNext(data)
            })
            .disposed(by: disposeBag)
        
        input.updateItem
            .bind(onNext: { updatedItem in
                if let index = data.firstIndex(where: { $0.id == updatedItem.id }) {
                    data[index] = updatedItem
                    list.onNext(data)
                }
            })
            .disposed(by: disposeBag)
        
        
        input.deleteItem
            .bind(onNext: { indexPath in
                data.remove(at: indexPath.row)
                list.onNext(data)
            })
            .disposed(by: disposeBag)
        
        return Output(tap: input.tap, list: list, modelSeleted: input.modelSeleted)
    }
}
