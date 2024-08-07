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
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    lazy var list = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    let viewModel = ShoppingListViewModel()
    let updateItem = PublishSubject<ShoppingList>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let input = ShoppingListViewModel.Input(tap: addButton.rx.tap,
                                                text: addListTextField.rx.text,
                                                modelSeleted: tableView.rx.modelSelected(ShoppingList.self), 
                                                updateItem: updateItem,
                                                deleteItem: tableView.rx.itemDeleted, 
                                                recentItemSelected: collectionView.rx.modelSelected(String.self))
        let output = viewModel.transform(input: input)
        
        output.list
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
        
        
        output.modelSeleted
            .bind(with: self) { owner, value in
                let editVC = EditShoppingListViewController()
                editVC.data = value
                
                editVC.editItem = { [weak self] updatedValue in
                    guard let self = self else { return }
                    self.updateItem.onNext(updatedValue)
                }
                owner.navigationController?.pushViewController(editVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.suggestedItem
            .bind(to: collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)){ item, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(addListTextField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemMint
        
        addListTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(addListTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }

        
        addListTextField.backgroundColor = .lightGray
        addButton.backgroundColor = .gray
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingCollectionViewCell")
        tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: "ShoppingListTableViewCell")
    }


    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 50)
        layout.scrollDirection = .horizontal
        return layout
    }

}
