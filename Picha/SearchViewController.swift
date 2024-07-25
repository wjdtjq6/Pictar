//
//  SearchViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit
import Then

class SearchViewController: BaseViewController {
    let searchBar = UISearchBar().then { _ in
    }
    let stackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureHierarchy() {
        view.addSubview(searchBar)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(44)
        }
    }
    override func configureUI() {
        navigationItem.title = "SEARCH PHOTO"
    }
}
