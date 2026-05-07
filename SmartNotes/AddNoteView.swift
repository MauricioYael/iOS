//
//  AddNoteView.swift
//  SmartNotes
//
//  Created by José Solís Romero on 07/05/26.
//

import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var category: NoteCategory = .personal
    
    var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Título") {
                    TextField("¿De qué trata esta nota?", text: $title)
                }
                
                Section("Categoría") {
                    Picker("Categoría", selection: $category) {
                        ForEach(NoteCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Contenido") {
                    TextEditor(text: $content)
                        .frame(minHeight: 180)
                }
            }
            .navigationTitle("Nueva nota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let note = Note(
                            title: title.trimmingCharacters(in: .whitespaces),
                            content: content,
                            category: category
                        )
                        viewModel.addNote(note)
                        dismiss()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
