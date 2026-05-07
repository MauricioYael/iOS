//
//  NoteRowView.swift
//  SmartNotes
//
//  Created by Mauricio Yael Pasten Jardon on 07/05/26.
//

import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    var categoryColor: Color {
        switch note.category {
        case .personal: return .blue
        case .trabajo:  return .green
        case .ideas:    return .purple
        case .urgente:  return .red
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Barra de color
            RoundedRectangle(cornerRadius: 3)
                .fill(categoryColor)
                .frame(width: 4, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(note.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    
                    Spacer()
                    
                    Text(note.updatedAt.formatted(.relative(presentation: .named)))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Text(note.preview.isEmpty ? "Sin contenido" : note.preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Etiqueta de categoría
                HStack(spacing: 4) {
                    Image(systemName: note.category.icon)
                        .font(.caption2)
                    Text(note.category.rawValue)
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundStyle(categoryColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(categoryColor.opacity(0.12))
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
