//
//  Note.swift
//  SmartNotes
//
//  Created by Mauricio Yael Pasten Jardon on 07/05/26.
//

import Foundation

enum NoteCategory: String, CaseIterable, Codable {
    case personal = "Personal"
    case trabajo = "Trabajo"
    case ideas = "Ideas"
    case urgente = "Urgente"
    
    var color: String {
        switch self {
        case .personal: return "blue"
        case .trabajo:  return "green"
        case .ideas:    return "purple"
        case .urgente:  return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .trabajo:  return "briefcase.fill"
        case .ideas:    return "lightbulb.fill"
        case .urgente:  return "exclamationmark.triangle.fill"
        }
    }
}

struct Note: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var category: NoteCategory
    var isPinned: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    var preview: String {
        let lines = content.components(separatedBy: "\n")
        return lines.first ?? ""
    }
}
