import SwiftUI

struct ContentView: View {
    // Usamos una tupla para estructurar el perfil del usuario
    let perfil: (nombre: String, edad: Int) = ("Mauricio Yael", 20)
    
    // Usamos una tupla para cada experiencia, en una lista
    let experiencias: [(titulo: String, descripcion: String)] = [
        ("Proyecto 1", "Desarrollo de una app móvil básica."),
        ("Proyecto 2", "Implementación de una interfaz de usuario en SwiftUI.")
    ]
    
    // Estado para el toggle (mostrar/ocultar detalles)
    @State private var mostrarDetalles = false
    
    // Estado para el slider (nivel de habilidades, por ejemplo)
    @State private var nivelHabilidades: Double = 0.5
    
    // Estado para mostrar la alerta
    @State private var mostrarAlerta = false
    
    var body: some View {
        ScrollView { // Usamos ScrollView para que el contenido sea desplazable si es necesario
            VStack(spacing: 20) {
                // Sección de Perfil con imagen y datos
                HStack {
                    // Imagen de perfil (usando una imagen del sistema, pero puedes reemplazar con una personalizada)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Nombre: \(perfil.nombre)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Edad: \(perfil.edad) años")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Toggle para mostrar/ocultar detalles adicionales
                Toggle("Mostrar detalles adicionales", isOn: $mostrarDetalles)
                    .padding(.horizontal)
                
                if mostrarDetalles {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Información adicional:")
                            .font(.headline)
                        Text("Intereses: Programación, diseño de apps, tecnología.")
                        Text("Habilidades: Swift, SwiftUI, Xcode.")
                    }
                    .padding(.horizontal)
                }
                
                // Slider para ajustar el nivel de habilidades (ejemplo: de 0 a 1)
                VStack {
                    Text("Nivel de Habilidades: \(Int(nivelHabilidades * 100))%")
                        .font(.subheadline)
                    Slider(value: $nivelHabilidades, in: 0...1, step: 0.1)
                        .padding(.horizontal)
                }
                
                // Sección de Experiencia
                VStack(alignment: .leading, spacing: 10) {
                    Text("Experiencia:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(experiencias, id: \.titulo) { experiencia in
                        VStack(alignment: .leading) {
                            Text(experiencia.titulo)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(experiencia.descripcion)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                
                // Botón que muestra una alerta
                Button(action: {
                    mostrarAlerta = true
                }) {
                    Text("Mostrar Más Información")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $mostrarAlerta) {
                    Alert(
                        title: Text("Información Adicional"),
                        message: Text("Este es un CV interactivo. Puedes ajustar el nivel de habilidades con el slider y alternar detalles con el toggle."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding(.vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
