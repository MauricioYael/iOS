//
//  NoteDetailView.swift
//  SmartNotes
//
//  Created by Mauricio Yael Pasten Jardon on 07/05/26.
//

import SwiftUI

struct NoteDetailView: View {
    @State var note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    @State private var editTitle = ""
    @State private var editContent = ""
    @State private var editCategory: NoteCategory = .personal
    @State private var showDeleteAlert = false
    
    var categoryColor: Color {
        switch note.category {
        case .personal: return .blue
        case .trabajo:  return .green
        case .ideas:    return .purple
        case .urgente:  return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header con categoría
                HStack {
                    Label(note.category.rawValue, systemImage: note.category.icon)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(categoryColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(categoryColor.opacity(0.12))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Editado")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if isEditing {
                    // Modo edición
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Título", text: $editTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Picker("Categoría", selection: $editCategory) {
                            ForEach(NoteCategory.allCases, id: \.self) { cat in
                                Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        TextEditor(text: $editContent)
                            .frame(minHeight: 300)
                            .font(.body)
                    }
                } else {
                    // Modo lectura
                    Text(note.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    Text(note.content.isEmpty ? "Sin contenido." : note.content)
                        .font(.body)
                        .foregroundStyle(note.content.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.togglePin(note)
                    // Refrescar estado local
                    if let updated = viewModel.notes.first(where: { $0.id == note.id }) {
                        note = updated
                    }
                } label: {
                    Image(systemName: note.isPinned ? "pin.slash" : "pin")
                }
                
                if isEditing {
                    Button("Guardar") {
                        note.title = editTitle
                        note.content = editContent
                        note.category = editCategory
                        viewModel.updateNote(note)
                        isEditing = false
                    }
                    .fontWeight(.semibold)
                } else {
                    Button("Editar") {
                        editTitle = note.title
                        editContent = note.content
                        editCategory = note.category
                        isEditing = true
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert("Eliminar nota", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                viewModel.deleteNote(note)
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("¿Seguro que quieres eliminar esta nota? No se puede deshacer.")
        }
    }
}
