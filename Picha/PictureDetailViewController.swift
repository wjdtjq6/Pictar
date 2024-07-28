//
//  PictureDetailViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/25/24.
//

import UIKit
import Then
import SnapKit

class PictureDetailViewController: BaseViewController {
    let userImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    var userName = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
    }
    var createdDate = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 11)
    }
    let likeFuncButton = UIButton().then {
        $0.setImage(UIImage(named: "like_circle"), for: .normal)
        $0.setImage(UIImage(named: "like_circle"), for: .selected)
        $0.addTarget(self, action: #selector(likeFuncButtonPressed), for: .touchUpInside)
    }
    var smallImage = UIImageView().then { _ in
    }
    let infoLabel = UILabel().then {
        $0.text = "정보"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    let sizeLabel = UILabel().then {
        $0.text = "크기"
        $0.font = .boldSystemFont(ofSize: 14)
    }
    var sizeValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    let countLabel = UILabel().then {
        $0.text = "조회수"
        $0.font = .boldSystemFont(ofSize: 14)
    }
    var countValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    let downloadLabel = UILabel().then {
        $0.text = "다운로드"
        $0.font = .boldSystemFont(ofSize: 14)
    }
    var downloadValueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    let chartLabel = UILabel().then {
        $0.text = "차트"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    let viewOrdownload = UISegmentedControl(items: ["조회","다운로드 "])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    override func configureHierarchy() {
        view.addSubview(userImage)
        view.addSubview(userName)
        view.addSubview(createdDate)
        view.addSubview(likeFuncButton)
        view.addSubview(smallImage)
        view.addSubview(infoLabel)
        view.addSubview(sizeLabel)
        view.addSubview(sizeValueLabel)
        view.addSubview(countLabel)
        view.addSubview(countValueLabel)
        view.addSubview(downloadLabel)
        view.addSubview(downloadValueLabel)
        view.addSubview(chartLabel)
        view.addSubview(viewOrdownload)
    }
    override func configureLayout() {
        userImage.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        userName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(userImage.snp.trailing).offset(5)
            make.centerY.equalTo(userImage).offset(-8)
        }
        createdDate.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(userImage.snp.trailing).offset(5)
            make.centerY.equalTo(userImage).offset(8)
        }
        likeFuncButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)//.offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide)//.inset(10)
            make.width.height.equalTo(60)
        }
        smallImage.snp.makeConstraints { make in
            make.top.equalTo(likeFuncButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(smallImage.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        sizeLabel.snp.makeConstraints { make in
            //make.top.equalTo(smallImage.snp.bottom).offset(15)
            make.leading.equalTo(infoLabel.snp.trailing).offset(60)
            make.centerY.equalTo(infoLabel.snp_centerYWithinMargins)
        }
        sizeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(smallImage.snp.bottom).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(infoLabel.snp_centerYWithinMargins)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.leading.equalTo(infoLabel.snp.trailing).offset(60)
        }
        countValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        downloadLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(13)
            make.leading.equalTo(infoLabel.snp.trailing).offset(60)
        }
        downloadValueLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(13)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        chartLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadLabel.snp.bottom).offset(25)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        viewOrdownload.snp.makeConstraints { make in
            make.centerY.equalTo(chartLabel.snp_centerYWithinMargins)
            make.leading.equalTo(chartLabel.snp.trailing).offset(55)
            make.width.equalTo(115)
            make.height.equalTo(27)
        }
    }
    override func configureUI() {
        navigationItem.title = ""
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        self.navigationController?.navigationBar.standardAppearance = appearence
    }
    @objc func likeFuncButtonPressed() {
        
    }
}
