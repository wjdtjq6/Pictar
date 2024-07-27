//
//  TopicViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class TopicViewController: BaseViewController {
    let profileButton = UIButton().then {
        $0.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)
        $0.backgroundColor = .greyColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.mainColor?.cgColor
        $0.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
    }
    let titleLabel = UILabel().then {
        $0.text = "OUR TOPIC"
        $0.font = .boldSystemFont(ofSize: 30)
    }
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(TopicTableViewCell.self, forCellReuseIdentifier: TopicTableViewCell.id)
        view.rowHeight = 300
        return view
    }()
    @objc func profileButtonPressed() {
        print(#function)
        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        UINavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    let headerTitles = ["골든 아워":"golden-hour",
//                        "비즈니스 및 업무":"business-work",
//                        "건축 및 인테리어":"architecture-interior"]
    let headerTitles = ["골든 아워", "비즈니스 및 업무", "건축 및 인테리어"]
    var goldenList = [Photos]()
    var buisnessList = [Photos]()
    var architectureList = [Photos]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        //TODO: 403
//        UnsplashAPI.shared.photos(api: .photos(topicID: "golden-hour"), model: [Photos].self) { value in
//            self.goldenList = value!
//            self.tableView.reloadData()
//        }
//        UnsplashAPI.shared.photos(api: .photos(topicID: "business-work"), model: [Photos].self) { value in
//            self.buisnessList = value!
//            self.tableView.reloadData()
//        }
//        UnsplashAPI.shared.photos(api: .photos(topicID: "architecture-interior"), model: [Photos].self) { value in
//            self.architectureList = value!
//            self.tableView.reloadData()
//        }
    }
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(profileButton)
        view.addSubview(tableView)
    }
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)//상단 빈 바 없애기
        tableView.separatorStyle = .none
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    //다음 뷰로 넘어갈 때 네비게이션문제 해결방법
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension TopicViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicTableViewCell.id, for: indexPath) as! TopicTableViewCell
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.id)
        cell.collectionView.tag = indexPath.section//빼먹어서 고생
        cell.collectionView.reloadData()
        return cell
    }
}
extension TopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(collectionView.tag)
        print(indexPath.item)
        let vc = PictureDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return goldenList.count
        case 1: return buisnessList.count
        case 2: return architectureList.count
        default: return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.id, for: indexPath) as! TopicCollectionViewCell
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.clipsToBounds = true
        switch collectionView.tag {
        case 0: let url = goldenList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(goldenList[indexPath.item].likes.formatted())  ", for: .normal)
        case 1: let url = buisnessList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(buisnessList[indexPath.item].likes.formatted())  ", for: .normal)
        case 2: let url = architectureList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(architectureList[indexPath.item].likes.formatted())  ", for: .normal)
        default:
            cell.imageView.image = UIImage(systemName: "star.fill")
            cell.likesButton.setTitle(" error  ", for: .normal)
        }
        return cell
    }
}
