//
//  main.swift
//  class_7
//
//  Created by José Solís Romero on 05/03/26.
//

import Foundation

enum MessageStatus: String {
    case enviado = "Enviado"
    case recibido = "Recibido"
    case leido = "Leído"
}
let status: MessageStatus = .enviado
print("status: \(status)")

switch status{
case .enviado:
    print("El mensaje fue enviado")
case .recibido:
    print("El mensaje fue recibido")
case .leido:
    print("El mensaje fue leído")
}

print("------------------")
print("status.rawValue")

enum PuntosCardinales: Int {
    case norte = 1
    case este
    case sur
    case oeste
}

let puntosCardinal: PuntosCardinales = .sur
print("puntosCardinal: \(puntosCardinal)")
print("rawValue: \(puntosCardinal.rawValue)")

enum Dias: Int {
    case lunes = 1
    case martes
    case miercoles
    case jueves
    case viernes
    case sabado
    case domingo
}

func dias(from number: Int) -> Dias?{
    Dias(rawValue: number)
}

if let dia = dias(from: 3){
    print("El dia numero 3 es el \(dia)")
}
else {
    print("Numero de dia invalido")
}

print("----------------")

enum Semaforo{
    case rojo
    case amarillo
    case verde
} // <-- Aquí estaba el error: faltaba esta llave de cierre

func action(for a: MessageStatus) -> String {
    switch a {
    case .enviado:
        return "Marcar como leido"
    case .recibido:
        return "Marcar como enviado"
    case .leido:
        return "Marcar como recibido"
    }
}

enum LoadState {
    case idle
    case loading
    case success(items: [String])
    case failure(message: String)
}

func render(_ state: LoadState) {
    switch state{
    case .idle:
        print("Listo para buscar")
    case .loading:
        print("Cargando...")
    case .success(let items):
        print("Resultado: \(items)")
    case .failure(let message):
        print("Error: \(message)")
    }
}

render(.idle)
render(.loading)
render(.success(items: ["item1", "item2", "item3"]))
render(.failure(message: "No se puede cargar"))

print("----------------------")
