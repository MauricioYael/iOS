// Actividad 11
// Creado por Mauricio Yael Pasten


import Foundation
  
enum NivelCurso: String {
    case basico      = "Básico"
    case intermedio  = "Intermedio"
    case avanzado    = "Avanzado"
}
 
enum EstadoAcademico: String {
    case reprobado = "Reprobado"
    case aprobado  = "Aprobado"
    case excelente = "Excelente"
}
 
 
struct Estudiante {
    let id: Int
    let nombre: String
    let edad: Int
    let correo: String
}
 
 
class Curso {
    let codigo: String
    let nombre: String
    let nivel: NivelCurso
    let cupoMaximo: Int
    private(set) var estudiantesInscritos: [Estudiante] = []
 
    init(codigo: String, nombre: String, nivel: NivelCurso, cupoMaximo: Int) {
        self.codigo      = codigo
        self.nombre      = nombre
        self.nivel       = nivel
        self.cupoMaximo  = cupoMaximo
    }
 

    func inscribir(estudiante: Estudiante) -> Bool {

        guard estudiantesInscritos.count < cupoMaximo else {
            print("Error: El curso '\(nombre)' ya alcanzó su cupo máximo.")
            return false
        }

        guard !estudiantesInscritos.contains(where: { $0.id == estudiante.id }) else {
            print("Error: \(estudiante.nombre) ya está inscrito en '\(nombre)'.")
            return false
        }
        estudiantesInscritos.append(estudiante)
        return true
    }
}
 

 
class Inscripcion {
    let estudiante: Estudiante
    let curso: Curso
    private(set) var calificaciones: [Double] = []
 
    init(estudiante: Estudiante, curso: Curso) {
        self.estudiante = estudiante
        self.curso      = curso
    }
 

    var promedio: Double {
        guard !calificaciones.isEmpty else { return 0.0 }
        return calificaciones.reduce(0, +) / Double(calificaciones.count)
    }
 
 
    var estadoAcademico: EstadoAcademico {
        switch promedio {
        case 9.0...:
            return .excelente
        case 6.0..<9.0:
            return .aprobado
        default:
            return .reprobado
        }
    }
 

    func agregarCalificacion(_ calificacion: Double) {
        guard calificacion >= 0.0 && calificacion <= 10.0 else {
            print("Error: La calificación \(calificacion) no es válida (debe estar entre 0 y 10).")
            return
        }
        calificaciones.append(calificacion)
        print("Calificación \(calificacion) agregada a \(estudiante.nombre).")
    }
}
 

 
class CampusSystem {
    private var estudiantes: [Estudiante]   = []
    private var cursos:      [Curso]        = []
    private var inscripciones: [Inscripcion] = []
 

    func registrarEstudiante(id: Int, nombre: String, edad: Int, correo: String) {
     
        guard !nombre.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Error: El nombre del estudiante no puede estar vacío.")
            return
        }
        guard edad >= 16 else {
            print("Error: La edad de '\(nombre)' debe ser mayor o igual a 16.")
            return
        }
        guard correo.contains("@") else {
            print("Error: El correo '\(correo)' no es válido.")
            return
        }
 
        let nuevo = Estudiante(id: id, nombre: nombre, edad: edad, correo: correo)
        estudiantes.append(nuevo)
        print("Estudiante \(nombre) agregado correctamente.")
    }
 
 
    func registrarCurso(codigo: String, nombre: String, nivel: NivelCurso, cupoMaximo: Int) {
        let nuevo = Curso(codigo: codigo, nombre: nombre, nivel: nivel, cupoMaximo: cupoMaximo)
        cursos.append(nuevo)
        print("Curso \(nombre) agregado correctamente.")
    }
 

    func inscribirEstudiante(estudianteId: Int, codigoCurso: String) {
        guard let estudiante = estudiantes.first(where: { $0.id == estudianteId }) else {
            print("Error: No se encontró un estudiante con id \(estudianteId).")
            return
        }
        guard let curso = cursos.first(where: { $0.codigo == codigoCurso }) else {
            print("Error: No se encontró el curso con código '\(codigoCurso)'.")
            return
        }

        guard !inscripciones.contains(where: { $0.estudiante.id == estudianteId && $0.curso.codigo == codigoCurso }) else {
            print("Error: \(estudiante.nombre) ya tiene una inscripción en '\(curso.nombre)'.")
            return
        }
 
        let resultado = curso.inscribir(estudiante: estudiante)
        guard resultado else { return }
 
        let inscripcion = Inscripcion(estudiante: estudiante, curso: curso)
        inscripciones.append(inscripcion)
        print("Inscripción realizada correctamente.")
    }
 
 
    func agregarCalificacion(estudianteId: Int, codigoCurso: String, calificacion: Double) {
        guard let inscripcion = inscripciones.first(where: {
            $0.estudiante.id == estudianteId && $0.curso.codigo == codigoCurso
        }) else {
            print("Error: No existe una inscripción para ese estudiante en ese curso.")
            return
        }
        inscripcion.agregarCalificacion(calificacion)
    }
 
 
    func mostrarReporte() {
        print("\n=== REPORTE FINAL ===")
        for inscripcion in inscripciones {
            let califs = inscripcion.calificaciones.map { String($0) }.joined(separator: ", ")
            let promedioFormateado = String(format: "%.2f", inscripcion.promedio)
            print("Estudiante: \(inscripcion.estudiante.nombre)")
            print("Curso: \(inscripcion.curso.nombre)")
            print("Calificaciones: [\(califs)]")
            print("Promedio: \(promedioFormateado)")
            print("Estado: \(inscripcion.estadoAcademico.rawValue)")
            print("----------------------")
        }
    }
}
 

 
let campus = CampusSystem()
 
// Registrar estudiantes
campus.registrarEstudiante(id: 1, nombre: "Ana",    edad: 20, correo: "ana@mail.com")
campus.registrarEstudiante(id: 2, nombre: "Carlos", edad: 22, correo: "carlos@mail.com")
campus.registrarEstudiante(id: 3, nombre: "Mia",    edad: 17, correo: "mia@mail.com")
 
// Intentar registro inválido (debería rechazarse)
campus.registrarEstudiante(id: 4, nombre: "",       edad: 25, correo: "x@mail.com")
campus.registrarEstudiante(id: 5, nombre: "Pablo",  edad: 14, correo: "pablo@mail.com")
campus.registrarEstudiante(id: 6, nombre: "Lucia",  edad: 19, correo: "sinArroba.com")
 
// Registrar cursos
campus.registrarCurso(codigo: "SW101", nombre: "Swift Básico",    nivel: .basico,     cupoMaximo: 2)
campus.registrarCurso(codigo: "SW201", nombre: "Swift Avanzado",  nivel: .avanzado,   cupoMaximo: 3)
 
// Inscribir estudiantes
campus.inscribirEstudiante(estudianteId: 1, codigoCurso: "SW101")
campus.inscribirEstudiante(estudianteId: 2, codigoCurso: "SW101")
campus.inscribirEstudiante(estudianteId: 3, codigoCurso: "SW101") // Cupo lleno
campus.inscribirEstudiante(estudianteId: 1, codigoCurso: "SW101") // Duplicado
campus.inscribirEstudiante(estudianteId: 1, codigoCurso: "SW201")
 
// Agregar calificaciones
campus.agregarCalificacion(estudianteId: 1, codigoCurso: "SW101", calificacion: 9.5)
campus.agregarCalificacion(estudianteId: 1, codigoCurso: "SW101", calificacion: 8.0)
campus.agregarCalificacion(estudianteId: 1, codigoCurso: "SW101", calificacion: 11.0) // Inválida
campus.agregarCalificacion(estudianteId: 2, codigoCurso: "SW101", calificacion: 5.5)
campus.agregarCalificacion(estudianteId: 2, codigoCurso: "SW101", calificacion: 4.0)
campus.agregarCalificacion(estudianteId: 1, codigoCurso: "SW201", calificacion: 9.8)
campus.agregarCalificacion(estudianteId: 1, codigoCurso: "SW201", calificacion: 10.0)
 
// Mostrar reporte
campus.mostrarReporte()
