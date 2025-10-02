//
//  ToastStyle.swift
//  TodayToDoList
//
//  Created by najak on 7/16/25.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

enum ToastPosition {
    case Top
    case Center
    case Bottom
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
