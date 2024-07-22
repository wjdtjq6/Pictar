//
//  ProfileViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import Then
import SnapKit

class ProfileViewController: BaseViewController {
    lazy var profileButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.mainColor?.cgColor
        $0.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
    }
    let profileCamera = UIImageView().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12)
        $0.image = UIImage(systemName: "camera.fill",withConfiguration: imageConfig)
        $0.backgroundColor = .mainColor
        $0.tintColor = .white
        $0.layer.cornerRadius = 12.5
        $0.contentMode = .center
    }
    lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요 :)"
        $0.addTarget(self, action: #selector(nicknameWarning), for: .editingChanged)
    }
    let separator = UIView().then {
        $0.backgroundColor = .lightGray
    }
    let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
    }
    let mbtiLabel = UILabel().then {
        $0.text = "MBTI"
        $0.font = .boldSystemFont(ofSize: 18)
    }
    let mbtiStackView = UIStackView().then {
        $0.backgroundColor = .lightGray
        $0.distribution = .fillEqually
    }
    let eiStackView = UIStackView().then {
        $0.backgroundColor = .red
        $0.distribution = .fillEqually
    }
//    let buttonE = UIButton().then {
//        $0.setTitle("E", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
//    let buttonI = UIButton().then {
//        $0.setTitle("E", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
    let snStackView = UIStackView().then {
        $0.backgroundColor = .orange
        $0.distribution = .fillEqually
    }
//    let buttonS = UIButton().then {
//        $0.setTitle("S", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
//    let buttonN = UIButton().then {
//        $0.setTitle("N", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
    let tfStackView = UIStackView().then {
        $0.backgroundColor = .yellow
        $0.distribution = .fillEqually
    }
//    let buttonT = UIButton().then {
//        $0.setTitle("T", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
//    let buttonF = UIButton().then {
//        $0.setTitle("F", for: .normal)
//        $0.setTitleColor(.mainColor, for: .selected)
//        $0.setTitleColor(.greyColor, for: .disabled)
//    }
    let jpStackView = UIStackView().then {
        $0.backgroundColor = .green
        $0.distribution = .fillEqually
    }
    //
    lazy var completeButton = UIButton().then {
        $0.tintColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    let warnings = ["@", "#", "$", "%", "  "]
    let mbtiButtons = [
            ["E","I"],
            ["S","N"],
            ["T","F"],
            ["J","P"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        setButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        profileButton.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)
    }
    override func configureHierarchy() {
        view.addSubview(profileButton)
        view.addSubview(profileCamera)
        view.addSubview(nicknameTextField)
        view.addSubview(separator)
        view.addSubview(warningLabel)
        view.addSubview(mbtiLabel)
        view.addSubview(mbtiStackView)
        mbtiStackView.addArrangedSubview(eiStackView)
        mbtiStackView.addArrangedSubview(snStackView)
        mbtiStackView.addArrangedSubview(tfStackView)
        mbtiStackView.addArrangedSubview(jpStackView)
        view.addSubview(completeButton)
    }
    func setButtons() {
        for i in mbtiButtons {
            for j in i {
                let button = UIButton().then {
                    $0.setTitle("\(j)", for: .normal)
                    $0.setTitleColor(.mainColor, for: .selected)
                    $0.setTitleColor(.greyColor, for: .disabled)
                }
                mbtiStackView.addArrangedSubview(button)
            }
        }
        
    }
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        profileCamera.snp.makeConstraints { make in
            make.bottom.equalTo(profileButton.snp.bottom).inset(5)
            make.trailing.equalTo(profileButton.snp.trailing).inset(5)
            make.width.height.equalTo(25)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(1)
        }
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
            
        }
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.width.equalTo(50)
        }
        mbtiStackView.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.width.equalTo(250)
            make.height.equalTo(150)
        }
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    override func configureUI() {
        navigationItem.backButtonTitle = ""
        if UserDefaults.standard.string(forKey: "profile") == nil {
            UserDefaults.standard.set(Int.random(in: 0...11), forKey: "profile")
        }
        profileButton.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)//맨 위에 있으면 nil

        if UserDefaults.standard.string(forKey: "nickname") != nil {
            navigationItem.title = "EDIT PROFILE"

            let rightBarButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))//pop??
            rightBarButton.setTitleTextAttributes([
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16) ,
                NSAttributedString.Key.foregroundColor : UIColor.black,
                ], for: .normal)
            navigationItem.rightBarButtonItem = rightBarButton
            
            nicknameTextField.text = UserDefaults.standard.string(forKey: "nickname")
        }
        else {
            navigationItem.title = "PROFILE SETTING"

            completeButton.setTitle("완료", for: .normal)
        }
        
    }
    @objc func completeButtonClicked() {
        if warningLabel.text == "사용할 수 있는 닉네임이에요" {
            warningLabel.textColor = .mainColor
            UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
            UserDefaults.standard.set(true, forKey: "isUser")
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let SceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let navigationController = TabBarController()
        
            SceneDelegate?.window?.rootViewController = navigationController
            SceneDelegate?.window?.makeKeyAndVisible()
        }
        
        if UserDefaults.standard.string(forKey: "date") == nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy.MM.dd"
            let str = df.string(from: Date())
            UserDefaults.standard.set(str, forKey: "date")
        }
    }
    @objc func nicknameWarning() {
        warningLabel.textColor = .warningColor

        if nicknameTextField.text!.contains(warnings[0]) {
            warningLabel.text = "닉네임에 @를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[1]) {
            warningLabel.text = "닉네임에 #를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[2]) {
            warningLabel.text = "닉네임에 $를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[3]) {
            warningLabel.text = "닉네임에 %를 포함할 수 없어요"
        }
        //스페이스바 두번 연속 불가능!
        else if nicknameTextField.text!.contains(warnings[4]) {
            warningLabel.text = "사용할 수 없는 닉네임입니다"
        }
        else if !(nicknameTextField.text!.count >= 2 && nicknameTextField.text!.count < 10) {
            warningLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
        }
        else {
            warningLabel.text = "사용할 수 있는 닉네임이에요"
            warningLabel.textColor = .mainColor
        }
        for i in 0...9 {
            if nicknameTextField.text!.contains("\(i)") {
                warningLabel.text = "닉네임에 숫자는 포함할 수 없어요"
                warningLabel.textColor = .warningColor
            }
        }
        //처음,끝 스페이스 불가능!
        var list:[Character] = []
        for i in nicknameTextField.text! {
            list.append(i)
        }
        if list.first == " " || list.last == " " {
            warningLabel.text = "사용할 수 없는 닉네임입니다"
            warningLabel.textColor = .warningColor
        }
    }
    @objc func profileButtonClicked() {
        let vc = ProfileImageSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
