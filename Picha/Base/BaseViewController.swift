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
    func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("fauled to download image:",error ?? "")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
}
extension UIColor {
    class var greyColor: UIColor? { return UIColor(named: "GreyColor") }
    class var mainColor: UIColor? { return UIColor(named: "MainColor") }
    class var warningColor: UIColor? { return UIColor(named: "warningColor") }
}
    
