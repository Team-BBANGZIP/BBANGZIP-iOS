//
//  CategoryColor.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/5/25.
//

import SwiftUI

enum CategoryColor: String, Codable, CaseIterable {
    case Todored1, Todoyellow1, Todogreen1, Todoblue1, Todopurple1
    case Todored2, Todoyellow2, Todogreen2, Todoblue2, Todopurple2
}

extension CategoryColor {
    var apiValue: String {
        switch self {
        case .Todored1: return "red1"
        case .Todoblue1: return "blue1"
        case .Todogreen1: return "green1"
        case .Todoyellow1: return "yellow1"
        case .Todopurple1: return "purple1"
        case .Todored2: return "red2"
        case .Todoblue2: return "blue2"
        case .Todogreen2: return "green2"
        case .Todoyellow2: return "yellow2"
        case .Todopurple2: return "purple2"
        }
    }
    
    static func fromAPI(_ api: String) -> CategoryColor {
        let key = api.uppercased()
        
        switch key {
        case "RED1": return .Todored1
        case "YELLOW1": return .Todoyellow1
        case "GREEN1": return .Todogreen1
        case "BLUE1": return .Todoblue1
        case "PURPLE1": return .Todopurple1
        case "RED2": return .Todored2
        case "YELLOW2": return .Todoyellow2
        case "GREEN2": return .Todogreen2
        case "BLUE2": return .Todoblue2
        case "PURPLE2": return .Todopurple2
        default:
            return .Todored1
        }
    }
    
    var displayColor: Color {
        Color(rawValue)
    }
}
