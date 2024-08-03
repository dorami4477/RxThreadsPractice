//
//  ShoppingList.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/2/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ShoppingList {
    let id:UUID
    var check:BehaviorRelay<Bool>
    var title:String
    var favorite:BehaviorRelay<Bool>
    
    init(title: String) {
        self.id = UUID()
        self.check = BehaviorRelay(value: false)
        self.title = title
        self.favorite = BehaviorRelay(value: false)
    }
}
