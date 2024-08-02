//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let discriptionLabel = UILabel()
    
    let disposeBag = DisposeBag()
    let phoneNumber = Observable.just("010")
    let discription = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        discription
            .bind(to: discriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let phoneText = phoneTextField.rx.text.orEmpty
        
        phoneText.map { Int($0) == nil }
            .bind(with: self) { owner, value in
                if value{
                    owner.discription.onNext("숫자만 입력하세요.")
                }
            }
            .disposed(by: disposeBag)
        
        phoneText.map { $0.count < 10 }
            .bind(with: self) { owner, value in
                if value{
                    owner.discription.onNext("10자리이상 입력하세요.")
                }
            }
            .disposed(by: disposeBag)
        
        phoneText.map { $0.count >= 10 && Int($0) != nil }
            .bind(with: self) { owner, value in
                if value{
                    owner.discription.onNext("")
                }
            }
            .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }


    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(discriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        discriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(discriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
