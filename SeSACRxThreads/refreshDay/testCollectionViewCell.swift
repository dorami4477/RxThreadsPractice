//
//  testCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/6/24.
//

import UIKit
import SnapKit

class testCollectionViewCell: UICollectionViewCell {
    static let id = "testCollectionViewCell"
    
    let background = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
