//
//  Color.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation
import UIKit

struct AppColorTheme {
    private init() {}
    static let shared = AppColorTheme()
    
    let backgroundColor = UIColor.darkGray
    let titleColor = UIColor.white
    let borderColor = UIColor.lightGray
    let placeholderTextColor = UIColor.lightGray
    let loginBtnTitleCOlor = UIColor.cyan
}
