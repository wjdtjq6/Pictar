//
//  TopicTableViewCell.swift
//  Picha
//
//  Created by t2023-m0032 on 7/24/24.
//

import UIKit
import SnapKit

class TopicTableViewCell: UITableViewCell {
    static let id = "TopicTableViewCell"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 280)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return object
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy() {
        contentView.addSubview(collectionView)
    }
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
