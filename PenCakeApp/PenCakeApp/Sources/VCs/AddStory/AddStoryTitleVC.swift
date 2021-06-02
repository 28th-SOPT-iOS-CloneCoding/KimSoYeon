//
//  AddStoryTitleVC.swift
//  PenCakeApp
//
//  Created by soyeon on 2021/05/28.
//

import UIKit

class AddStoryTitleVC: UIViewController {
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(touchUpCloseButton(_:)))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSerif(.light, size: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        return button
    }()
    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(touchUpNextButton(_:)))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.NotoSerif(.light, size: 13)], for: .normal)
        
        return button
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "새 이야기를 추가합니다."
        label.font = UIFont.NotoSerif(.light, size: 13)
        
        return label
    }()
    private lazy var subContentLabel: UILabel = {
        let label = UILabel()
        label.text = "이야기의 제목을 입력해주세요."
        label.font = UIFont.NotoSerif(.light, size: 13)
        
        return label
    }()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "예) 일기, 일상을 끄적이다", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.font = .NotoSerif(.light, size: 13)
        textField.removeAuto()
        return textField
    }()
    
    private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigation()
    }
}

// MARK: - UI
extension AddStoryTitleVC {
    func setUI() {
        view.backgroundColor = .white
        
        view.addSubviews([contentLabel, subContentLabel, titleTextField, bottomLine])
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        subContentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(subContentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        titleTextField.becomeFirstResponder()
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(1)
        }
    }

    func setNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()

        self.navigationItem.leftBarButtonItem = self.closeButton
        self.navigationItem.rightBarButtonItem = self.nextButton
    }
}

// MARK: - Action
extension AddStoryTitleVC {
    @objc func touchUpCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc func touchUpNextButton(_ sender: UIBarButtonItem) {
        if ((titleTextField.text?.isEmpty) != nil) {
            let nextVC = AddStorySubTitleVC()
            nextVC.storyTitle = titleTextField.text
            
            self.navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(nextVC, animated: true)
            
        } else {
            let alertViewController = UIAlertController(title: nil,
                                                        message: "제목을 입력해주세요.",
                                                        preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertViewController.addAction(okAction)
            present(alertViewController, animated: true, completion: nil)
        }
    }
}
