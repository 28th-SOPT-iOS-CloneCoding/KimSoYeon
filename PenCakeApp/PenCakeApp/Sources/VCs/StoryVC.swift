//
//  MainVC.swift
//  PenCakeApp
//
//  Created by soyeon on 2021/05/27.
//

import UIKit
import SnapKit
import RealmSwift

class StoryVC: UIViewController {
    // MARK: - UIComponents

    private let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        view.backgroundColor = .white
        view.clipsToBounds = true

        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5

        return view
    }()

    private let titleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("이야기 1", for: .normal)
        btn.titleLabel?.font = UIFont.NotoSerif(.semiBold, size: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.sizeToFit()

        return btn
    }()

    private let subTitleButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("여기를 눌러서 제목을 변경하세요", for: .normal)
        btn.titleLabel?.font = UIFont.NotoSerif(.light, size: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.sizeToFit()

        return btn
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        table.contentOffset.y = -200

        return table
    }()

    private lazy var newWritingControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(addNewWriting(_:)), for: .valueChanged)
        control.tintColor = .clear

        return control
    }()

    // MARK: - local variables

    var viewModel: StoryViewModel

    // MARK: - Initializer

    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.storyDelegate = self

        setUI()
        setTableView()
        setNavigationBar()
    }
}

// MARK: - Action Methods

extension StoryVC {
    @objc func addNewWriting(_ sender: UIRefreshControl) {
        sender.endRefreshing()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let writingVC = UINavigationController(rootViewController: WritingVC())
            writingVC.modalPresentationStyle = .overFullScreen

            self.present(writingVC, animated: true, completion: nil)
        }
    }
    
    @objc func reloadTableView(_ sender: Notification) {
        tableView.reloadData()
    }
}

// MARK: - Custom Methods

extension StoryVC {
    func setUI() {
        view.backgroundColor = .white
        
        view.addSubviews([tableView, headerView])
        headerView.addSubviews([titleButton, subTitleButton, separator])

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        separator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }

        titleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }

        subTitleButton.snp.makeConstraints { make in
            make.centerX.equalTo(titleButton.snp.centerX)
            make.top.equalTo(titleButton.snp.bottom).offset(10)
        }
    }

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(WritingTVC.self, forCellReuseIdentifier: WritingTVC.identifier)
        tableView.refreshControl = newWritingControl

        tableView.separatorStyle = .none
    }

    func setNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: Notification.Name.savedNewStory, object: nil)
    }
}

// MARK: - UITableViewDelegate

extension StoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .zero
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = min(max(y, 100), 250)

        headerView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

// MARK: - UITableViewDataSource

extension StoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let story = viewModel.story {
            return story.writings.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WritingTVC.identifier) as? WritingTVC else { return UITableViewCell() }
        if let story = viewModel.story {
            cell.setCellData(writing: story.writings[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - StoryViewModelDelegate

extension StoryVC: StoryViewModelDelegate {
    func changedStory(story: Story) {
        titleButton.setTitle(story.title, for: .normal)
        subTitleButton.setTitle(story.subTitle, for: .normal)

        tableView.reloadData()
    }
}
