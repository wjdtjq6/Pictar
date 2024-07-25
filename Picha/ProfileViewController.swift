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
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    let eiStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 10
    }
    let snStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 10
    }
    let tfStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 10
    }
    let jpStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.spacing = 10
    }
    let completeButton = UIButton()
    let withdrawButton = UIButton()
    let warnings = ["@", "#", "$", "%", "  "]
    let mbtiButtons = [
            ["E","I"],
            ["S","N"],
            ["T","F"],
            ["J","P"]
    ]
    var selectedMBTI: [String: Int] = [:]//TODO: completebuttonpress에만 저장되도록!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        setButtons()
        if navigationItem.title == "EDIT PROFILE" {
            completeButton.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        mbtiButtonsShow()
    }
    func mbtiButtonsShow() {
        let ei = UserDefaults.standard.value(forKey: "EI") as? Int
        let sn = UserDefaults.standard.value(forKey: "SN") as? Int
        let tf = UserDefaults.standard.value(forKey: "TF") as? Int
        let jp = UserDefaults.standard.value(forKey: "JP") as? Int
        if let ei {
            updateButtonSelection(buttons: eiButtons, selectedTag: ei)
        }
        if let sn {
            updateButtonSelection(buttons: snButtons, selectedTag: sn)
        }
        if let tf {
            updateButtonSelection(buttons: tfButtons, selectedTag: tf)
        }
        if let jp {
            updateButtonSelection(buttons: jpButtons, selectedTag: jp)
        }
    }
    func updateButtonSelection(buttons: [UIButton], selectedTag: Int) {
        for button in buttons {
            if button.tag == selectedTag {
                button.isSelected = true
                button.backgroundColor = .mainColor
            } else {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
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
        view.addSubview(withdrawButton)
    }
    func setButtons() {
        var tagCount: [String] = []
        for i in 0...3 {
            for j in mbtiButtons[i] {
                tagCount.append(j)
                let button = UIButton().then {
                    $0.setTitle("\(j)", for: .normal)
                    $0.setTitleColor(.white, for: .selected)
                    $0.setTitleColor(.greyColor, for: .normal)
                    $0.layer.cornerRadius = 27.5
                    $0.layer.borderWidth = 1
                    $0.layer.borderColor = UIColor.greyColor?.cgColor
                    $0.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
                    $0.tag = tagCount.count
                    $0.isSelected = false

                }
                switch i {
                    case 0:
                        eiStackView.addArrangedSubview(button)
                        eiButtons.append(button)
                    case 1:
                        snStackView.addArrangedSubview(button)
                        snButtons.append(button)
                    case 2:
                        tfStackView.addArrangedSubview(button)
                        tfButtons.append(button)
                    case 3:
                        jpStackView.addArrangedSubview(button)
                        jpButtons.append(button)
                    default:
                        break
                }
            }
        }
    }
    var eiButtons: [UIButton] = []
    var snButtons: [UIButton] = []
    var tfButtons: [UIButton] = []
    var jpButtons: [UIButton] = []
    @objc func buttonPressed(sender: UIButton) {
        switch sender.tag {
        case 1, 2:
            updateSelection(buttons: eiButtons, selectedButton: sender, mbtiType: "EI")
        case 3, 4:
            updateSelection(buttons: snButtons, selectedButton: sender, mbtiType: "SN")
        case 5, 6:
            updateSelection(buttons: tfButtons, selectedButton: sender, mbtiType: "TF")
        case 7, 8:
            updateSelection(buttons: jpButtons, selectedButton: sender, mbtiType: "JP")
        default:
            print("error")
        }
        completeButtonChanges()
    }
    func updateSelection(buttons: [UIButton], selectedButton: UIButton, mbtiType: String) {
        for button in buttons {
            if button.tag == selectedButton.tag {
                button.isSelected.toggle()
                if button.isSelected {
                    button.backgroundColor = .mainColor
                    selectedMBTI[mbtiType] = button.tag
                } else {
                    button.backgroundColor = .white
                    selectedMBTI.removeValue(forKey: mbtiType)
                }
            }
            else {
                button.isSelected = false
                button.backgroundColor = .white
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
            make.height.equalTo(120)
        }
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        withdrawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(10)
        }
    }
    override func configureUI() {
        navigationItem.backButtonTitle = ""
        if UserDefaults.standard.string(forKey: "profile") == nil {
            UserDefaults.standard.set(Int.random(in: 0...11), forKey: "profile")
        }
        profileButton.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)//맨 위에 있으면 nil
        
        //닉네임 유무가 아니라 "isUser"유무로 해도될듯
        if (UserDefaults.standard.string(forKey: "nickname") != nil)/* && (UserDefaults.standard.string(forKey: "1") != nil || UserDefaults.standard.string(forKey: "2") != nil) && (UserDefaults.standard.string(forKey: "3") != nil || UserDefaults.standard.string(forKey: "4") != nil) && (UserDefaults.standard.string(forKey: "5") != nil || UserDefaults.standard.string(forKey: "6") != nil) && (UserDefaults.standard.string(forKey: "7") != nil || UserDefaults.standard.string(forKey: "8") != nil) */{
            navigationItem.title = "EDIT PROFILE"

            let rightBarButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))//pop??
            rightBarButton.setTitleTextAttributes([
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16) ,
                NSAttributedString.Key.foregroundColor : UIColor.black,
                ], for: .normal)
            navigationItem.rightBarButtonItem = rightBarButton
            
            nicknameTextField.text = UserDefaults.standard.string(forKey: "nickname")
            
            let title = "회원탈퇴"
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.systemFont(ofSize: 13)
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            withdrawButton.setAttributedTitle(attributedTitle, for: .normal)
            withdrawButton.setTitleColor(.mainColor, for: .normal)
            withdrawButton.addTarget(self, action: #selector(withdrawButtonPressed), for: .touchUpInside)
        }
        else {
            navigationItem.title = "PROFILE SETTING"
            completeButton.tintColor = .white
            completeButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            completeButton.backgroundColor = .greyColor
            completeButton.layer.cornerRadius = 25
            completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
            completeButton.isEnabled = true
            completeButton.setTitle("완료", for: .normal)
        }
    }
    @objc func withdrawButtonPressed() {
        print(#function)
    }
    func completeButtonChanges() {
        print(selectedMBTI)
        //.count가 아니라...userdefault에 모두 있으면!
        if UserDefaults.standard.value(forKey: "EI") && (warningLabel.text == "사용할 수 있는 닉네임이에요" || warningLabel.text == "") {
            completeButton.backgroundColor = .mainColor
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            completeButton.backgroundColor = .greyColor
            completeButton.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    @objc func completeButtonClicked() {
        UserDefaults.standard.set(selectedMBTI["EI"], forKey: "EI")
        UserDefaults.standard.set(selectedMBTI["SN"], forKey: "SN")
        UserDefaults.standard.set(selectedMBTI["TF"], forKey: "TF")
        UserDefaults.standard.set(selectedMBTI["JP"], forKey: "JP")
        UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let SceneDelegate = windowScene?.delegate as? SceneDelegate

        let navigationController = TabBarController()

        SceneDelegate?.window?.rootViewController = navigationController
        SceneDelegate?.window?.makeKeyAndVisible()
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
        completeButtonChanges()
    }
    @objc func profileButtonClicked() {
        let vc = ProfileImageSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
