//
//  MigrationHelper.swift
//  MinecraftServerStatus
//
//  Created by Tomer on 5/19/21.
//  Copyright © 2021 ShemeshApps. All rights reserved.
//

import Foundation
import RealmSwift

let VERSION = 1

func migrationIfNeeded() {
    let lastVer = getLastVersion()
    if lastVer < VERSION {
        for i in lastVer...VERSION{
            runMigrationForVer(version: i)
        }
        setCurrentVersion(version: VERSION)
    }
}


func runMigrationForVer(version: Int) {
    switch version {
    case 0:
        insertColors()
    default:
        return
    }
}

func insertColors() {
    let realm = initializeRealmDb()

    let color1 = WidgetBackgroundColor(color: UIColor(hex: "")!)
    let color2 = WidgetBackgroundColor(color: UIColor(hex: "")!)
    let color3 = WidgetBackgroundColor(color: UIColor(hex: "")!)

    try! realm.write {
        realm.add(color1)
        realm.add(color2)
        realm.add(color3)
    }
}


func getLastVersion() -> Int {
    return  UserDefaults.standard.integer(forKey: "appVer")
}

func setCurrentVersion(version: Int) {
    UserDefaults.standard.set(version, forKey: "appVer")
}
