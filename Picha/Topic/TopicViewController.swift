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
import RealmSwift

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
    var list = Statistics(id: "", downloads: Downloads(total: 0), views: Views(total: 0))
    let realm = try! Realm()
    var realmList: Results<LikeList>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        UnsplashAPI.shared.photos(api: .photos(topicID: "golden-hour"), model: [Photos].self) {[self] value in
            goldenList = value!
            tableView.reloadData()
        }
        UnsplashAPI.shared.photos(api: .photos(topicID: "business-work"), model: [Photos].self) { value in
            self.buisnessList = value!
            self.tableView.reloadData()
        }
        UnsplashAPI.shared.photos(api: .photos(topicID: "architecture-interior"), model: [Photos].self) { value in
            self.architectureList = value!
            self.tableView.reloadData()
        }
        realmList = realm.objects(LikeList.self)
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
        let vc = PictureDetailViewController()
        let goldenData = goldenList[indexPath.item]
        let bData = buisnessList[indexPath.item]
        let aData = architectureList[indexPath.item]

        func fetchDataAndAddToRealm(imageID: String, data: Photos, group: DispatchGroup) {
            group.enter()
            UnsplashAPI.shared.photosStatistics(api: .photosStatistics(imageID: imageID), model: Statistics.self) { value in
                guard let list = value else {
                    group.leave()
                    return
                }
                let newData = LikeList(id: list.id, date: Date(), userImage: data.user.profile_image.medium, smallImage: data.urls.small, userName: data.user.name, createdDate: data.created_at, width: data.width, height: data.height, count: list.views.total, downloadValue: list.downloads.total)
                self.addDataToRealm(data: newData)
                group.leave()
            }
        }

        let group = DispatchGroup()

        if collectionView.tag == 0 {
            fetchDataAndAddToRealm(imageID: goldenData.id, data: goldenData, group: group)
        } else if collectionView.tag == 1 {
            fetchDataAndAddToRealm(imageID: bData.id, data: bData, group: group)
        } else {
            fetchDataAndAddToRealm(imageID: aData.id, data: aData, group: group)
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.updateUI(vc: vc)
        }
    }

    private func addDataToRealm(data: LikeList) {
        do {
            try self.realm.write {
                self.realm.add(data)
                print("Data added to Realm: \(data)")
            }
        } catch {
            print("Realm error: \(error)")
        }
    }

    private func updateUI(vc: PictureDetailViewController) {
        if let lastItem = realmList.last {
            let userImageUrl = lastItem.userImage
            vc.userImage.kf.setImage(with: URL(string: userImageUrl))
            let smallImageUrl = lastItem.smallImage
            vc.smallImage.kf.setImage(with: URL(string: smallImageUrl))
            vc.userName.text = lastItem.userName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let convertDate = dateFormatter.date(from: lastItem.createdDate) {
                let myDateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "yyyy년 MM월 dd일 게시됨"
                let convertStr = myDateFormatter.string(from: convertDate)
                vc.createdDate.text = convertStr
            }
            vc.sizeValueLabel.text = "\(lastItem.width) x \(lastItem.height)"
            vc.countValueLabel.text = "\(lastItem.count)"
            vc.downloadValueLabel.text = "\(lastItem.downloadValue)"
        } else {
            print("realm list is empty")
        }

        navigationController?.pushViewController(vc, animated: true)
        vc.hidesBottomBarWhenPushed = true
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
        //likesButton
        cell.likesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.likesButton.backgroundColor = .greyColor
        
        switch collectionView.tag {
        case 0:
            let url = goldenList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(goldenList[indexPath.item].likes.formatted())  ", for: .normal)
        case 1:
            let url = buisnessList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(buisnessList[indexPath.item].likes.formatted())  ", for: .normal)
        case 2:
            let url = architectureList[indexPath.item].urls.small
            cell.imageView.kf.setImage(with: URL(string: url))
            cell.likesButton.setTitle(" \(architectureList[indexPath.item].likes.formatted())  ", for: .normal)
        default:
            cell.imageView.image = UIImage(systemName: "star.fill")
            cell.likesButton.setTitle(" error  ", for: .normal)
        }
        
        return cell
    }
}