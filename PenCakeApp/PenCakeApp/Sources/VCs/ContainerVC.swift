//
//  ContainerVC.swift
//  PenCakeApp
//
//  Created by soyeon on 2021/05/27.
//

import RealmSwift
import UIKit

class ContainerVC: UIPageViewController {
    private lazy var moreButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
        button.addTarget(self, action: #selector(touchUpMoreButton(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large), forImageIn: .normal)
        button.tintColor = UIColor.systemGray4
        button.backgroundColor = .white
        
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        return button
    }()
    
    static var pages: [UIViewController] = [AddStoryVC()]
    static var currPage: Int = ContainerVC.pages.count - 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRealm()
        setUI()
        setPageController()
        setNotification()
    }
}

// MARK: - Action

extension ContainerVC {
    @objc func touchUpMoreButton(_ sender: UIButton) {
        if ContainerVC.currPage == 0 {
            let dvc = SettingVC()
            
            dvc.isStoryPage = false
            SettingVC.storyNum = ContainerVC.currPage
            
            dvc.modalTransitionStyle = .crossDissolve
            dvc.modalPresentationStyle = .fullScreen
            self.present(dvc, animated: true, completion: nil)
        } else {
            let dvc = SettingVC()
            
            dvc.isStoryPage = true
            SettingVC.storyNum = ContainerVC.currPage
            
            dvc.modalTransitionStyle = .crossDissolve
            dvc.modalPresentationStyle = .fullScreen
            self.present(dvc, animated: true, completion: nil)
        }
    }
    
    @objc func changeCurrPage(_ sender: Notification) {
        guard let newStoryVC = sender.object as? StoryVC else { return }
        guard let index = ContainerVC.pages.firstIndex(of: newStoryVC) else { return }
        ContainerVC.currPage = index
        setViewControllers([ContainerVC.pages[index]], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: - Fix: 이야기 삭제 후 화면 전환
    @objc func deletePage(_ sender: Notification) {
        guard let deleteStoryVC = sender.object as? StoryVC else { return }
        guard let index = ContainerVC.pages.firstIndex(of: deleteStoryVC) else { return }
        ContainerVC.currPage = index - 1
        setViewControllers([ContainerVC.pages[index]], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - UI

extension ContainerVC {
    private func setRealm() {
        Database.shared.initStoryData()
    }
    
    private func setUI() {
        view.addSubviews([moreButton])
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
            make.width.height.equalTo(60)
        }
        
        moreButton.layer.cornerRadius = moreButton.frame.height / 2
        moreButton.layer.masksToBounds = true
    }
    
    private func setPageController() {
        setViewControllers([ContainerVC.pages[ContainerVC.currPage]], direction: .forward, animated: true, completion: nil)
        
        dataSource = self
        delegate = self
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrPage(_:)), name: Notification.Name.savedNewStory, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePage(_:)), name: Notification.Name.deletedStory, object: nil)
    }
}

// MARK: - UIPageViewControllerDelegate

extension ContainerVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currVC = viewControllers?.first {
                guard let index = ContainerVC.pages.firstIndex(of: currVC) else { return }
                ContainerVC.currPage = index
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ContainerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = ContainerVC.pages.firstIndex(of: viewController) else { return nil }

        return idx + 1 >= ContainerVC.pages.count ? nil : ContainerVC.pages[idx + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = ContainerVC.pages.firstIndex(of: viewController) else { return nil }

        return idx - 1 < 0 ? nil : ContainerVC.pages[idx - 1]
    }
}
