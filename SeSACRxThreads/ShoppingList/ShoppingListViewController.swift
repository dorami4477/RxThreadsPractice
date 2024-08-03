//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {

    let addListTextField = {
        let tf = UITextField()
        tf.placeholder = "무엇을 구매하실 건가요?"
        return tf
    }()
    let addButton = {
        let btn = UIButton()
        btn.setTitle("추가", for: .normal)
        return btn
    }()
    let tableView = UITableView()
    
    var data = [
        ShoppingList(title: "그립톡 구매하기"),
        ShoppingList(title: "사이다 구메"),
        ShoppingList(title: "양말")
    ]
    lazy var list = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)){ row, element, cell in

                cell.titleLabel.text = element.title
            
                element.check
                    .map { $0 ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square") }
                    .bind(to: cell.checkButton.rx.image(for: .normal))
                    .disposed(by: cell.disposeBag)
                
                element.favorite
                    .map{ $0 ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")}
                    .bind(to: cell.favoriteButton.rx.image(for: .normal))
                    .disposed(by: cell.disposeBag)
                
                cell.checkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let currentValue = element.check.value
                        element.check.accept(!currentValue)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteButton.rx.tap
                    .bind { _ in
                        element.favorite.accept(!element.favorite.value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withLatestFrom(addListTextField.rx.text.orEmpty) { void, text in
                return text
               }
            .bind(with: self, onNext: { owener, value in
                let newItem = ShoppingList(title: value)
                owener.data.insert(newItem, at: 0)
                owener.list.onNext(owener.data)
            })
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(addListTextField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        addListTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addListTextField.snp.bottom).offset(20)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addListTextField.backgroundColor = .lightGray
        addButton.backgroundColor = .gray
        tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: "ShoppingListTableViewCell")
    }



}
