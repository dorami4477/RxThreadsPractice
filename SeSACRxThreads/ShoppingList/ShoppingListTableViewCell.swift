//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/3/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingListTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingListTableViewCell"
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    let checkButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return button
    }()
    let titleLabel = UILabel()
    
    let favoriteButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        checkButton.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
    }
}
