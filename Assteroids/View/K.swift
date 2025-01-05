//
//  K.swift
//  Assteroids
//
//  Created by Marcus Kim on 8/26/24.
//

import Foundation

enum K {
    static let left = "left"
    static let right = "right"
    static let leftArrowName = "leftArrowNode"
    static let rightArrowName = "rightArrowNode"
    static let spaceshipAssetName = "hand.point.right"
    static let flameAssetName = "flame"
    static let missileAssetName = "hand.point.right.fill"
    static let assAssetName = "flippedAss"
    static let missileCategory: UInt32 = 0b0001
    static let largeAssteroidCategory: UInt32 = 0b0010
    static let mediumAssteroidCategory: UInt32 = 0b0100
    static let smallAssteroidCategory: UInt32 = 0b1000
    static let largeAssteroidSize: CGSize = CGSize(width: 100.0, height: 100.0)
    static let mediumAssteroidSize: CGSize = CGSize(width: 75.0, height: 75.0)
    static let smallAssteroidSize: CGSize = CGSize(width: 50.0, height: 50.0)
}
