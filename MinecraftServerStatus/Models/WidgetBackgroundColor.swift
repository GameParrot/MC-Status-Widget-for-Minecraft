//
//  WidgetBackgroundColor.swift
//  MinecraftServerStatus
//
//  Created by Tomer on 5/19/21.
//  Copyright © 2021 ShemeshApps. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//color model for the database
public class WidgetBackgroundColor: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var colorStr = ""
    
    convenience init(color: UIColor) {
        self.init()
        self.colorStr = color.htmlRGBaColor
    }
    
    public func getColor() -> UIColor {
        return UIColor(hex: colorStr)!
    }

}
