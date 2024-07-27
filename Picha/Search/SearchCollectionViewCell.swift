//
//  SearchCollectionViewCell.swift
//  Picha
//
//  Created by t2023-m0032 on 7/26/24.
//

import UIKit
import Then
import SnapKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    static let id = "SearchCollectionViewCell"
    let buttonConfig = UIButton.Configuration.filled()

    let colorButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 13)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .lightGrey
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func configureHierarchy() {
        contentView.addSubview(colorButton)
    }
    override func configureLayout() {
        colorButton.snp.makeConstraints { make in
//            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
//            make.height.lessThanOrEqualTo(50)
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    override func configureUI() {
        
    }
}
