//
//  LikeSearchViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import Then
import SnapKit
import RealmSwift

class LikeSearchViewController: BaseViewController {
    let toggleButton = UIButton().then {
        $0.setTitle("최신순", for: .normal)
        $0.setTitle("과거순", for: .selected)
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
        $0.text = "저장된 사진이 없어요."
        $0.font = .systemFont(ofSize: 20)
        $0.isHidden = true
    }
    //create 1.Realm 위치 찾기
    let realm = try! Realm()
    var realmList: Results<LikeList>!//realm 빈애열?
    //var list = Search(total_pages: 0, results: [])
    var likeList: [UIImage] = []
    @objc func toggleButtonPressed() {
        toggleButton.isSelected.toggle()
        
        if toggleButton.isSelected {
            // 날짜 기준으로 내림차순 정렬 및 좋아요가 된 항목만 필터링
            realmList = realm.objects(LikeList.self)
                .filter("isLike = true")
                .sorted(byKeyPath: "date", ascending: false)
        } else {
            // 날짜 기준으로 오름차순 정렬 및 좋아요가 된 항목만 필터링
            realmList = realm.objects(LikeList.self)
                .filter("isLike = true")
                .sorted(byKeyPath: "date", ascending: true)
        }
        
        bottomCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        // 초기화 시 좋아요가 된 항목만 로드
        realmList = realm.objects(LikeList.self).filter("isLike = true")
        print(realm.configuration.fileURL)
    }

    override func viewWillAppear(_ animated: Bool) {
        bottomCollectionView.reloadData()
        isEmpty()
    }
    func isEmpty() {
        if realmList.isEmpty {
            noResultLabel.isHidden = false
        } else {
            noResultLabel.isHidden = true
        }
    }
    override func configureHierarchy() {
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(toggleButton)
        view.addSubview(noResultLabel)
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.id)
        view.addSubview(noResultLabel)
    }
    override func configureLayout() {
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
            make.width.equalTo(65)
        }
        topCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
        navigationItem.title = "MY POLAROID"
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        self.navigationController?.navigationBar.standardAppearance = appearence
        topCollectionView.showsHorizontalScrollIndicator = false
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
}
extension LikeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PictureDetailViewController()
        vc.hidesBottomBarWhenPushed = true

        if collectionView == bottomCollectionView {
            // LikeSearchViewController의 bottomCollectionView에서 선택된 경우
            let realmData = realmList[indexPath.item]
            let imageID = realmData.id
            
            vc.userImage.image = loadImageToDocument(filename: imageID+"_user")
            vc.smallImage.image = loadImageToDocument(filename: imageID)
            vc.userName.text = realmData.userName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let convertDate = dateFormatter.date(from: realmData.createdDate) {
                let myDateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "yyyy년 MM월 dd일 게시됨"
                let convertStr = myDateFormatter.string(from: convertDate)
                vc.createdDate.text = convertStr
            }
            vc.sizeValueLabel.text = "\(realmData.width) x \(realmData.height)"
            vc.countValueLabel.text = "\(realmData.count)"
            vc.downloadValueLabel.text = "\(realmData.downloadValue)"
            vc.likeFuncButton.isSelected = realmData.isLike
            vc.detailID = realmData.id//detailviewcontroller에서 사용
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            Colors.allCases.count
        } else {
            realmList.count
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.id, for: indexPath) as! TopicCollectionViewCell
            let realmData = realmList[indexPath.item]
            cell.likeFuncButton.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
            cell.likeFuncButton.tag = indexPath.item
            cell.likeFuncButton.setImage(UIImage(named: "like_circle"), for: .normal)
//            if let existingLike = realmList.first(where: { $0.id == realmData.id }) {
//                updateLikeButton(button: cell.likeFuncButton, isLiked: existingLike.isLiked)
//            }
            cell.imageView.image = loadImageToDocument(filename: realmData.id)
            return cell
        }
    }
    @objc func likeButtonPressed(sender: UIButton) {
        let realmData = realmList[sender.tag]
        try! realm.write {
            realmData.isLike.toggle()
            
            if !realmData.isLike {
                removeImageFromDocument(filename: realmData.id)
                realm.delete(realmData)
            }
        }
        bottomCollectionView.reloadData()
        isEmpty()
        self.view.makeToast("좋아요 목록에서 제거됐어요!")
    }
}
