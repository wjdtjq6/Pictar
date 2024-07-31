//
//  SearchViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RealmSwift
import Toast

class SearchViewController: BaseViewController {
    let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
    }
    let separatorView = UIView().then {
        $0.backgroundColor = .lightGrey
    }
    let toggleButton = UIButton().then {
        $0.setTitle("관련순", for: .normal)
        $0.setTitle("최신순", for: .selected)
        $0.setImage(UIImage(named: "sort"), for: .normal)
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGrey.cgColor
        $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
    }
    let topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width =  UIScreen.main.bounds.width - 60
        layout.itemSize = CGSize(width: width/6, height: 25)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return object
    }()
    let bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 15
        layout.itemSize = CGSize(width: width/2, height: 250)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return object
    }()
    let noResultLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.font = .systemFont(ofSize: 20)
        $0.isHidden = true
    }
    //MARK: 질문
    //var list = [SearchResults]()
    //var list: [SearchResults] = []

    //var list = [Search]()
    var searchList = Search(total_pages: 0, results: [])
    /*== var list = Search?
        {
            didSet {
                bottomCollectionView.reloadData()
            }
        } */
    var query = ""
    var page = 1
    //create 1.Realm 위치 찾기
    let realm = try! Realm()
    var realmList: Results<LikeList>!//realm 빈애열?
    var StatisticsList = Statistics(id: "", downloads: Downloads(total: 0), views: Views(total: 0))
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        //bottomCollectionView.reloadData() //왜 필요한지 모르겠음
        realmList = realm.objects(LikeList.self)//realm 빈배열에 realm값 넣어주기?
        print(realm.configuration.fileURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        bottomCollectionView.reloadData()
    }
    override func configureHierarchy() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        view.addSubview(separatorView)
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(toggleButton)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.id)
        view.addSubview(noResultLabel)
        bottomCollectionView.prefetchDataSource = self//pagenation
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(44)
        }
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
            make.width.equalTo(65)
        }
        topCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        bottomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        noResultLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureUI() {
        navigationItem.title = "SEARCH PHOTO"
        topCollectionView.showsHorizontalScrollIndicator = false
        topCollectionView.keyboardDismissMode = .onDrag //keyboard hide
        bottomCollectionView.keyboardDismissMode = .onDrag //keyboard hide
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    //keyboard hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    @objc func toggleButtonPressed() {
        toggleButton.isSelected.toggle()
        //pagenation start
        page = 1
        toggleCall()
        bottomCollectionView.setContentOffset(.zero, animated: true)
    }
    func toggleCall() {
        if toggleButton.isSelected {
            callAPI(query: query, order_by: "latest")
        } else {
            callAPI(query: query, order_by: "relevant")
        }
    }
    func callAPI(query: String, order_by: String) {
        UnsplashAPI.shared.search(api: .search(query: query, page: page, pre_page: 20,order_by: order_by/*, color: Colors.black_and_white.rawValue*/), model: Search.self) { value in
            if value!.results.isEmpty {
                self.noResultLabel.isHidden = false
                self.bottomCollectionView.isHidden = true
            } else {
                self.noResultLabel.isHidden = true
                self.bottomCollectionView.isHidden = false
                //pagenation
                if self.page == 1 {
                    self.searchList = value!
                } else {
                    self.searchList.results.append(contentsOf: value!.results)
                }
                self.bottomCollectionView.reloadData()
                
                if self.page == 1 && self.searchList.results.isEmpty {
                    self.bottomCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == searchList.results.count-1 && page < searchList.total_pages {
                page += 1
                toggleCall()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text!
        page = 1
        bottomCollectionView.setContentOffset(.zero, animated: true)
        toggleCall()
        searchBar.text = ""
    }
   //pagenation end
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PictureDetailViewController()
        let imageID = searchList.results[indexPath.item].id
        let data = searchList.results[indexPath.item]

        let group = DispatchGroup()

        // Enter the group to handle the statistics fetch
        group.enter()
        UnsplashAPI.shared.photosStatistics(api: .photosStatistics(imageID: imageID), model: Statistics.self) { value in
            guard let list = value else {
                group.leave()
                return
            }
            let newData = LikeList(id: list.id, date: Date(), userImage: data.user.profile_image.medium, smallImage: data.urls.small, userName: data.user.name, createdDate: data.created_at, width: data.width, height: data.height, count: list.views.total, downloadValue: list.downloads.total, isLike: self.realmList.first(where: { $0.id == imageID })?.isLike ?? false)
            self.addDataToRealm(data: newData)
            group.leave()
        }

        group.enter()
        if let url = URL(string: data.urls.small) {
            downloadImage(from: url) { image in
                if let image = image {
                    self.saveImageToDocument(image: image, filename: imageID)
                }
                group.leave()
            }
        } else {
            group.leave()
        }
        group.enter()
        if let url = URL(string: data.user.profile_image.medium) {
            downloadImage(from: url) { image in
                if let image = image {
                    self.saveImageToDocument(image: image, filename: imageID+"_user")
                }
                group.leave()
            }
        } else {
            group.leave()
        }

        // Notify when all tasks are complete
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.updateUI(vc: vc, imageID: imageID)
        }
    }


    private func addDataToRealm(data: LikeList) {
        let existingData = realm.objects(LikeList.self).filter("id == %@", data.id).first
        if existingData == nil {
            do {
                try self.realm.write {
                    self.realm.add(data)
                    print("Data added to Realm: \(data)")
                }
            } catch {
                print("Realm error: \(error)")
            }
        } else {
            print("Data already exists in Realm: \(data)")
        }
    }
    
    private func updateUI(vc: PictureDetailViewController, imageID: String) {
        if let data = realm.objects(LikeList.self).filter("id == %@", imageID).first {
            let userImageUrl = data.userImage
            //vc.userImage.kf.setImage(with: URL(string: userImageUrl))
            vc.userImage.image = loadImageToDocument(filename: data.id+"_user")
            let smallImageUrl = data.smallImage
            //vc.smallImage.kf.setImage(with: URL(string: smallImageUrl))
            vc.smallImage.image = loadImageToDocument(filename: data.id)
            vc.userName.text = data.userName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let convertDate = dateFormatter.date(from: data.createdDate) {
                let myDateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "yyyy년 MM월 dd일 게시됨"
                let convertStr = myDateFormatter.string(from: convertDate)
                vc.createdDate.text = convertStr
            }
            vc.sizeValueLabel.text = "\(data.width) x \(data.height)"
            vc.countValueLabel.text = "\(data.count)"
            vc.downloadValueLabel.text = "\(data.downloadValue)"
            vc.likeFuncButton.isSelected = data.isLike
            vc.detailID = data.id//detailviewcontroller에서 사용
        } else {
            print("realm list is empty")
        }

        navigationController?.pushViewController(vc, animated: true)
        vc.hidesBottomBarWhenPushed = true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            Colors.allCases.count
        } else {
            //TODO: var list = Search?하면 deque??해야하나? 옵셔널해제로 되나?
            searchList.results.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell
            if indexPath.item == 0 {
                cell.colorButton.setImage(UIImage(named: "blackAndWhite"), for: .normal)
                cell.colorButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 35)
            } else {
                cell.colorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cell.colorButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            if indexPath.item == Colors.allCases.count - 1 {
                cell.colorButton.isHidden = true
            } else {
                cell.colorButton.isHidden = false
            }
            cell.tintColor = Colors.allCases[indexPath.item].color
            cell.colorButton.setTitle(Colors.allCases[indexPath.item].name, for: .normal)
            return cell
        } else { // collectionView == bottomCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.id, for: indexPath) as! TopicCollectionViewCell
            let result = searchList.results[indexPath.item]
            
            // Configure like button
            let isLiked = realmList.first(where: { $0.id == result.id })?.isLike ?? false
            cell.likeFuncButton.isSelected = isLiked
            cell.likeFuncButton.setImage(UIImage(named: "like_circle"), for: .selected)
            cell.likeFuncButton.setImage(UIImage(named: "like_circle_inactive"), for: .normal)
            cell.likeFuncButton.tag = indexPath.item
            cell.likeFuncButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
            
            // Configure likes button
            cell.likesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.likesButton.backgroundColor = .greyColor
            
            // Configure image view
            let urlString = result.urls.small
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
            cell.likesButton.setTitle(" \(result.likes.formatted())  ", for: .normal)
            
            return cell
        }
    }

    
    @objc func likeButtonPressed(sender: UIButton) {
        let index = searchList.results[sender.tag]
        let imageID = index.id

        if let existingLike = realmList.first(where: { $0.id == imageID }) {
            // 기존 항목의 경우: `isLike` 값을 반전시키고, 이미지 삭제 필요
            try! realm.write {
                existingLike.isLike.toggle()
                let isLikeNow = existingLike.isLike
                if !isLikeNow {
                    removeImageFromDocument(filename: imageID)
                    removeImageFromDocument(filename: imageID + "_user")
                }
                sender.isSelected = isLikeNow
            }
            self.view.makeToast("좋아요 목록에 추가됐어요!")
        } else {
            // 기존 항목이 아닌 경우: 새 항목을 추가하고 `isLike` 값을 `true`로 설정
            let group = DispatchGroup()

            let newLikeData = LikeList(
                id: imageID,
                date: Date(),
                userImage: index.user.profile_image.medium,
                smallImage: index.urls.small,
                userName: index.user.name,
                createdDate: index.created_at,
                width: index.width,
                height: index.height,
                count: 0, // 초기화 시점에는 count와 downloadValue를 0으로 설정
                downloadValue: 0,
                isLike: true // 새 항목을 추가할 때 `isLike`를 `true`로 설정
            )

            group.enter()
            UnsplashAPI.shared.photosStatistics(api: .photosStatistics(imageID: imageID), model: Statistics.self) { value in
                guard let stats = value else {
                    group.leave()
                    return
                }

                try! self.realm.write {
                    newLikeData.count = stats.views.total
                    newLikeData.downloadValue = stats.downloads.total
                    self.realm.add(newLikeData)
                    sender.isSelected = true
                }

                // 이미지 다운로드
                let imageURL = URL(string: index.urls.small)
                group.enter()
                if let url = imageURL {
                    self.downloadImage(from: url) { image in
                        if let image = image {
                            self.saveImageToDocument(image: image, filename: imageID)
                        }
                        group.leave()
                    }
                } else {
                    group.leave()
                }

                // 사용자 이미지 다운로드
                let userImageURL = URL(string: index.user.profile_image.medium)
                group.enter()
                if let url = userImageURL {
                    self.downloadImage(from: url) { image in
                        if let image = image {
                            self.saveImageToDocument(image: image, filename: imageID + "_user")
                        }
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.view.makeToast("좋아요 목록에서 제거됐어요!")
            }
        }
    }

}

