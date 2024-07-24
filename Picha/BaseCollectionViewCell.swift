//
//  BaseCollectionViewCell.swift
//  Picha
//
//  Created by t2023-m0032 on 7/24/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy() {
        
    }
    func configureLayout() {
        
    }
    func configureUI() {
        
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
