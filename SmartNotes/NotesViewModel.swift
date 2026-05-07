//
//  NotesViewModel.swift
//  SmartNotes
//
//  Created by Mauricio Yael Pasten Jardon on 07/05/26.
//

import Foundation
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: NoteCategory? = nil
    
    private let saveKey = "saved_notes"
    
    init() {
        load()
    }
    
    var filteredNotes: [Note] {
        var result = notes
        
        if let cat = selectedCategory {
            result = result.filter { $0.category == cat }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted {
            if $0.isPinned != $1.isPinned { return $0.isPinned }
            return $0.updatedAt > $1.updatedAt
        }
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0)
        save()
    }
    
    func updateNote(_ note: Note) {
        if let i = notes.firstIndex(where: { $0.id == note.id }) {
            var updated = note
            updated.updatedAt = Date()
            notes[i] = updated
            save()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        save()
    }
    
    func togglePin(_ note: Note) {
        if let i = notes.firstIndex(where: { $0.id == note.id }) {
            notes[i].isPinned.toggle()
            save()
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}
