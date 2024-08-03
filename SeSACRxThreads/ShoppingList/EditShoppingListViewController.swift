//
//  EditShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/3/24.
//

import UIKit

class EditShoppingListViewController: UIViewController {
    var data:ShoppingList = ShoppingList(title: ""){
        didSet{
            listTextField.text = data.title
        }
    }
    
    let listTextField = UITextField()
    let textLabel = UILabel()
    
    var editItem:((ShoppingList) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let text = listTextField.text!
        data.title = text
        editItem?(data)
    }
    

    func configureView() {
        view.addSubview(listTextField)
        view.addSubview(textLabel)
        listTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(listTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        listTextField.backgroundColor = .lightGray
        listTextField.textColor = .black
    }
 

    func configureData(data: ShoppingList) {
        listTextField.text = data.title
    }
}
