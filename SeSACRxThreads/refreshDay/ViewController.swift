//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

class ViewController: UIViewController {

    lazy var collection = UICollectionView(frame: .zero, collectionViewLayout: layout())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.size.equalTo(370)
            make.center.equalToSuperview()
        }
        collection.register(testCollectionViewCell.self, forCellWithReuseIdentifier: testCollectionViewCell.id)
    }

    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 1, height: 1)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }

}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(whatIsThis[0].count)
        return whatIsThis[0].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print(whatIsThis.count)
        return whatIsThis.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: testCollectionViewCell.id, for: indexPath) as! testCollectionViewCell
//        print(whatIsThis[51][indexPath.item])
        print(indexPath.section)
        
//        print(whatIsThis[indexPath.section][indexPath.item])
//        for i in 0...whatIsThis.count - 1 {
//            if whatIsThis[i][indexPath.item] == 1 {
//                print(indexPath.section)
//                print("===")
//                cell.background.backgroundColor = .black
//            } else {
//                cell.backgroundColor = .yellow
//            
//            }
//        }
        if whatIsThis[indexPath.section][indexPath.item] == 1{
            cell.background.backgroundColor = .black
        } else {
            cell.backgroundColor = .yellow
        }
        
//        for items in whatIsThis {
//            for item in items {
//                if item == 1 {
//                    cell.backgroundColor = .black
//                } else {
//                    cell.backgroundColor = .white
//                }
//            }
//        }
//        
        return cell
    }
    
    
}
