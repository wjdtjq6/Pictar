//
//  ViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import SnapKit
import Then

class OnBoardingViewController: BaseViewController {
    let titleLabel = UILabel().then {
        $0.text = "Pictar"
        $0.font = .boldSystemFont(ofSize: 50)
        $0.textColor = .mainColor
    }
    let launchImage = UIImageView().then {
        $0.image = UIImage(named: "launchImg")
    }
    let nameLabel = UILabel().then {
        $0.text = "소정섭"
        $0.font = .boldSystemFont(ofSize: 30)
    }
    let startButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 25
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
    }
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(launchImage)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonPressed) , for: .touchUpInside)
    }
    @objc func startButtonPressed() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
        UserDefaults.standard.set(nil, forKey: "nickname")
        UserDefaults.standard.set(nil, forKey: "profile")
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(600)
        }
        launchImage.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(launchImage.snp.bottom).offset(10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}

