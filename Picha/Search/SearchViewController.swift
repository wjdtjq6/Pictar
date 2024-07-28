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
    var list = Search(total_pages: 0, results: [])
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
                    self.list = value!
                } else {
                    self.list.results.append(contentsOf: value!.results)
                }
                self.bottomCollectionView.reloadData()
                
                if self.page == 1 && self.list.results.isEmpty {
                    self.bottomCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == list.results.count-1 && page < list.total_pages {
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
        print(indexPath.item)
        let vc = PictureDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            Colors.allCases.count
        } else {
            //TODO: var list = Search?하면 deque??해야하나? 옵셔널해제로 되나?
            list.results.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.id, for: indexPath) as! SearchCollectionViewCell
            if indexPath.item == 0 {
                //그냥 circle.fill gray로 바꿀까...
                cell.colorButton.setImage(UIImage(named: "blackAndWhite"), for: .normal)
                cell.colorButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 35)
            } else {
                cell.colorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                cell.colorButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            if indexPath.item == Colors.allCases.count-1 {
                cell.colorButton.isHidden = true
            } else {
                cell.colorButton.isHidden = false
            }
            cell.tintColor = Colors.allCases[indexPath.item].color
            cell.colorButton.setTitle(Colors.allCases[indexPath.item].name, for: .normal)
            return cell
        }
        else /*collectionView == bottomCollectionView*/ {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.id, for: indexPath) as! TopicCollectionViewCell
            cell.likeFuncButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
            cell.likeFuncButton.tag = indexPath.item
            cell.likeFuncButton.setImage(UIImage(named: "like_circle_inactive"), for: .normal)//버튼 누리기 전에 안보여서
            if let existingLike = realmList.first(where: { $0.id == list.results[indexPath.item].id }) {
                //updateLikeButton(button: cell.likeFuncButton, isLiked: existingLike.isLiked)
                cell.likeFuncButton.setImage(UIImage(named:"like_circle"), for: .normal)
            }
            //likesButton
            cell.likesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.likesButton.backgroundColor = .greyColor
            //
            //TODO: var list = Search? 하면 deque??해야하나? 옵셔널해제로 되나?
            let urlString = list.results[indexPath.item].urls.small
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
            cell.likesButton.setTitle(" \(list.results[indexPath.item].likes.formatted())  ", for: .normal)
            return cell
        }
    }
    func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("fauled to download image:",error ?? "")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
    @objc func likeButtonPressed(sender: UIButton) {
        let photoID = list.results[sender.tag].id
        
        if let existingLike = realmList.first(where: { $0.id == photoID }) {
            try! realm.write{
                removeImageFromDocumnet(filename: photoID)
                sender.setImage(UIImage(named: "like_circle_inactive"), for: .normal)
                realm.delete(existingLike)
            }
        } 
        else {
            let data = LikeList(id: photoID, date: Date())
            try! realm.write{
                realm.add(data)
                sender.setImage(UIImage(named: "like_circle"), for: .normal)
                let urlString = list.results[sender.tag].urls.small
                if let url = URL(string: urlString) {
                    downloadImage(from: url) { image in
                        if let image = image {
                            self.saveImageToDocument(image: image, filename: photoID)
                        }
                    }
                }
            }
        }
    }
}
