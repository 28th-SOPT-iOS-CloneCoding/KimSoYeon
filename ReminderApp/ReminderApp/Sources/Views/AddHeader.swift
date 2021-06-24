//
//  AddHeader.swift
//  ReminderApp
//
//  Created by soyeon on 2021/06/25.
//

import UIKit
import SnapKit

class AddHeader: UIView {

    // MARK: - UIComponents
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.sizeToFit()
        return button
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.sizeToFit()
        button.isEnabled = true
        return button
    }()
    
    var titleLable: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Local Variables
    
    private var viewController: UIViewController?
    private var addNewAlertVC: AddNewAlertVC?
    
    // MARK: - LifeCycle Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(root viewController: UIViewController, with addNewAlertVC: AddNewAlertVC) {
        super.init(frame: .zero)
        self.viewController = viewController
        self.addNewAlertVC = addNewAlertVC
        addSubviews([cancelButton, addButton])
        setButtonAction()
    }
    
    override func layoutSubviews() {
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalToSuperview().inset(18)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview().inset(18)
        }
    }
    
    // MARK: - Action Methods
    
    private func setButtonAction() {
        let cancelAction = UIAction { _ in
            self.viewController?.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
    }
}
