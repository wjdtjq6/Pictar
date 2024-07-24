//
//  TopicCollectionViewCell.swift
//  Picha
//
//  Created by t2023-m0032 on 7/24/24.
//

import UIKit
import SnapKit

class TopicCollectionViewCell: BaseCollectionViewCell {
    static let id = "TopicCollectionViewCell"
    let likeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star.fill"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
        $0.setTitle(" 1,000  ", for: .normal)
        $0.tintColor = .systemYellow
        $0.backgroundColor = .greyColor
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 10)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func configureHierarchy() {
        contentView.addSubview(likeButton)
    }
    override func configureLayout() {
        likeButton.snp.makeConstraints { make in
            make.bottom.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    override func configureUI() {
    }
}
