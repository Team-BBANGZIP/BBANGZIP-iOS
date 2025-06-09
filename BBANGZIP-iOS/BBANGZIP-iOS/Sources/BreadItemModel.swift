//
//  BreadItemModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/26/25.
//

import SwiftUI

struct BreadItemModel: Identifiable {
    let id = UUID()
    let breadName: String
    let isUnlocked: Bool
    let isSelected: Bool
}
