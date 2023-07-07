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
    
    let backgroundColor = UIColor(named: "background")!
    let titleColor = UIColor(named: "title")!
    let borderColor = UIColor(named: "border")!
    let placeholderTextColor = UIColor(named: "placeholder")!
    let loginBtnTitleCOlor = UIColor(named: "buttonTitle")!
}
