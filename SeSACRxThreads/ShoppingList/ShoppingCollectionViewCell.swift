//
//  ShoppingCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/7/24.
//

import UIKit

class ShoppingCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShoppingCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
