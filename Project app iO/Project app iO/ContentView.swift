//
//  ContentView.swift
//  Project app iO
//
//  Created by José Solís Romero on 31/01/26.
//

import SwiftUI

struct ContentView: View {
    var nombre = "Mauricio Yael"
    let edad = "20"
    var experiencia = ["proyecto 1, proyecto 2"]
    var body: some View {
        VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Nombre: \(nombre) edad: \(edad)")
                    ForEach (experiencia, id: \.self) { proyecto in Text("\(proyecto)")
                    }
                }
                .padding()
            }
        }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
