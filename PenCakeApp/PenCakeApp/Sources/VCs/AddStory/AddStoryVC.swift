//
//  AddStoryVC.swift
//  PenCakeApp
//
//  Created by soyeon on 2021/05/24.
//

import UIKit
import SnapKit
import RealmSwift

class AddStoryVC: UIViewController {
    private lazy var addStoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemGray4
        button.setPreferredSymbolConfiguration(.init(pointSize: 50,
                                                     weight: .light,
                                                     scale: .large),
                                               forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(touchUpAdd(_:)),
                         for: .touchUpInside)
        return button
    }()
    private let newLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 를 눌러서 새 이야기를 시작하세요."
        label.textColor = .systemGray3
        label.font = UIFont.NotoSerif(.light, size: 13)
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension AddStoryVC {
    func setUI() {
        view.addSubviews([addStoryButton, newLabel])
        
        addStoryButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.height.equalTo(100)
        }
        newLabel.snp.makeConstraints { make in
            make.top.equalTo(addStoryButton.snp.bottom).offset(10)
            make.centerX.equalTo(addStoryButton)
        }
    }
}

extension AddStoryVC {
    @objc func touchUpAdd(_ : UIButton) {
        let titleVC = AddStoryTitleVC()
        let navigationController = UINavigationController(rootViewController: titleVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
