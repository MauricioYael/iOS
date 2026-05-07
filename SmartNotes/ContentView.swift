//
//  ContentView.swift
//  SmartNotes
//
//  Created by Mauricio Yael Pasten Jardon on 07/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filtros de categoría
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryFilterChip(
                            title: "Todas",
                            icon: "tray.fill",
                            isSelected: viewModel.selectedCategory == nil
                        ) {
                            viewModel.selectedCategory = nil
                        }
                        
                        ForEach(NoteCategory.allCases, id: \.self) { cat in
                            CategoryFilterChip(
                                title: cat.rawValue,
                                icon: cat.icon,
                                color: colorFor(cat),
                                isSelected: viewModel.selectedCategory == cat
                            ) {
                                viewModel.selectedCategory = (viewModel.selectedCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                // Lista de notas
                if viewModel.filteredNotes.isEmpty {
                    EmptyStateView(hasFilter: viewModel.selectedCategory != nil || !viewModel.searchText.isEmpty)
                } else {
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView(note: note, viewModel: viewModel)) {
                                NoteRowView(note: note)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.togglePin(note)
                                } label: {
                                    Label(note.isPinned ? "Desfijar" : "Fijar",
                                          systemImage: note.isPinned ? "pin.slash" : "pin")
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteNote(note)
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("SmartNotes")
            .searchable(text: $viewModel.searchText, prompt: "Buscar notas...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: viewModel)
            }
        }
    }
    
    func colorFor(_ cat: NoteCategory) -> Color {
        switch cat {
        case .personal: return .blue
        case .trabajo:  return .green
        case .ideas:    return .purple
        case .urgente:  return .red
        }
    }
}

// Chip de filtro
struct CategoryFilterChip: View {
    let title: String
    let icon: String
    var color: Color = .gray
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? color : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

// Estado vacío
struct EmptyStateView: View {
    let hasFilter: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasFilter ? "magnifyingglass" : "note.text")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text(hasFilter ? "Sin resultados" : "No hay notas aún")
                .font(.title2)
                .fontWeight(.semibold)
            Text(hasFilter ? "Prueba con otra búsqueda o categoría" : "Toca + para crear tu primera nota")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
