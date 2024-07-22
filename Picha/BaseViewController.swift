//
//  BaseViewController.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
}
extension UIColor {
    class var greyColor: UIColor? { return UIColor(named: "GreyColor") }
    class var mainColor: UIColor? { return UIColor(named: "MainColor") }
    class var warningColor: UIColor? { return UIColor(named: "warningColor") }
}
    
