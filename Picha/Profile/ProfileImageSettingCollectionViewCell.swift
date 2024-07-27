//
//  ProfileImageSettingCollectionViewCell.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit

class ProfileImageSettingCollectionViewCell: UICollectionViewCell {
    let profileImage = UIImageView()
    static let id = "ProfileImageSettingCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.greyColor?.cgColor
        profileImage.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
