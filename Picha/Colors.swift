//
//  Colors.swift
//  Picha
//
//  Created by t2023-m0032 on 7/26/24.
//

import Foundation
import UIKit
@frozen
enum Colors: String, CaseIterable {
    case black_and_white ,black, white, yellow, orange, red, purple, magenta, green, teal ,blue ,empty
    
    var color: UIColor {
        switch self {
        case .black_and_white: 
            return .clear
        case .black: 
            return .black
        case .white: 
            return .white
        case .yellow: 
            return .systemYellow
        case .orange: 
            return .orange
        case .red: 
            return .red
        case .purple: 
            return .purple
        case .magenta: 
            return .magenta
        case .green: 
            return .systemGreen
        case .teal: 
            return .systemTeal
        case .blue: 
            return .systemBlue
        case .empty:
            return .clear
        }
    }
    var name: String {
        switch self {
        case .black_and_white:
            return "흑백 "
        case .black:
            return "블랙 "
        case .white:
            return "화이트 "
        case .yellow:
            return "옐로우 "
        case .orange:
            return "오렌지 "
        case .red:
            return "레드 "
        case .purple:
            return "퍼플 "
        case .magenta:
            return "마젠타 "
        case .green:
            return "그린 "
        case .teal:
            return "틸 "
        case .blue:
            return "블루 "
        case .empty:
            return ""
        }
    }
}
