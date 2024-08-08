//
//  MovieViewController.swift
//  SeSACRxThreads
//
//  Created by 박다현 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MovieViewController: UIViewController {

    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = MovieViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    func bind() {
        let recentText = PublishSubject<String>()
        let input = MovieViewModel.Input(recentText: recentText, searchButtonTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)){ row, element, cell in
                cell.label.text = element.movieNm
            }
            .disposed(by: disposeBag)

        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)){ row, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .map{"\($0.0), \($0.1)"}
            .bind(with: self) { owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 50)
        return layout
    }



}
