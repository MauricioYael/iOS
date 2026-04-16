class Usuario {
 
    // MARK: Propiedades
 
    var nombre: String                      // internal (público en módulo)
    var email: String                       // internal
    private var password: String            // solo visible dentro de esta clase
    private(set) var activo: Bool           // lectura pública, escritura solo interna
 
    // MARK: Inicializadores
 
    /// Inicializador completo
    init(nombre: String, email: String, password: String, activo: Bool = true) {
        self.nombre   = nombre
        self.email    = email
        self.password = password
        self.activo   = activo
    }
 
    /// Inicializador alternativo con valores por defecto
    convenience init(nombre: String, email: String) {
        self.init(nombre: nombre, email: email, password: "123456", activo: false)
    }
 
    // MARK: Métodos
 
    /// Verifica la contraseña sin exponer el valor almacenado.
    func login(password: String) -> Bool {
        return self.password == password
    }
 
    /// Cambia la contraseña si la actual es correcta y la nueva tiene ≥ 6 caracteres.
    @discardableResult
    func cambiarPassword(actual: String, nueva: String) -> Bool {
        guard actual == password else {
            print("Error: contraseña actual incorrecta.")
            return false
        }
        guard nueva.count >= 6 else {
            print("Error: la nueva contraseña debe tener al menos 6 caracteres.")
            return false
        }
        password = nueva
        print("Contraseña actualizada correctamente.")
        return true
    }
 
    func activar() {
        activo = true
        print("\(nombre) ha sido activado.")
    }
 
    func desactivar() {
        activo = false
        print("\(nombre) ha sido desactivado.")
    }
 
    func descripcion() {
        print("""
        ── Usuario ──────────────────────────
        Nombre : \(nombre)
        Email  : \(email)
        Activo : \(activo)
        """)
    }
 
    // MARK: Acceso interno para subclases del mismo módulo
 
    /// Permite a Administrador resetear la contraseña respetando encapsulación.
    /// Al estar en el mismo archivo (fileprivate efectivo en módulo de un solo archivo),
    /// se expone solo lo mínimo necesario con internal scope.
    func _resetPassword(nueva: String) {
        password = nueva
    }
}
 
// ============================================================
// MARK: - Subclase: Administrador
// ============================================================
 
class Administrador: Usuario {
 
    // MARK: Propiedades
 
    var nivelAcceso: Int    // internal
 
    // MARK: Inicializador
 
    init(nombre: String, email: String, password: String, nivelAcceso: Int) {
        self.nivelAcceso = nivelAcceso
        super.init(nombre: nombre, email: email, password: password)
    }
 
    // MARK: Métodos
 
    override func descripcion() {
        print("""
        ── Administrador ────────────────────
        Nombre       : \(nombre)
        Email        : \(email)
        Activo       : \(activo)
        Nivel acceso : \(nivelAcceso)
        """)
    }
 
    /// Desactiva a un usuario. Requiere nivelAcceso ≥ 5.
    func eliminarUsuario(_ usuario: Usuario) {
        guard nivelAcceso >= 5 else {
            print("Permiso denegado: se requiere nivel 5 o superior para eliminar usuarios.")
            return
        }
        usuario.desactivar()
        print("Administrador \(nombre) ha desactivado a \(usuario.nombre).")
    }
 
    /// Resetea la contraseña de otro usuario. Requiere nivelAcceso ≥ 3.
    func resetearPassword(usuario: Usuario, nueva: String) {
        guard nivelAcceso >= 3 else {
            print("Permiso denegado: se requiere nivel 3 o superior para resetear contraseñas.")
            return
        }
        guard nueva.count >= 6 else {
            print("Error: la nueva contraseña debe tener al menos 6 caracteres.")
            return
        }
        // Usamos el método internal expuesto mínimamente, sin acceder a 'password' directamente.
        usuario._resetPassword(nueva: nueva)
        print("Contraseña de \(usuario.nombre) reseteada por \(nombre).")
    }
}
 
// ============================================================
// MARK: - Subclase: Cliente
// ============================================================
 
class Cliente: Usuario {
 
    // MARK: Propiedades
 
    private var saldo: Double                           // solo dentro de Cliente
    fileprivate var historialCompras: [String] = []    // accesible dentro del archivo
 
    // MARK: Inicializador
 
    init(nombre: String, email: String, password: String, saldoInicial: Double = 0.0) {
        self.saldo = saldoInicial
        super.init(nombre: nombre, email: email, password: password)
    }
 
    // MARK: Métodos
 
    /// Deposita una cantidad positiva en la cuenta.
    func depositar(_ cantidad: Double) {
        guard cantidad > 0 else {
            print("Error: la cantidad a depositar debe ser positiva.")
            return
        }
        saldo += cantidad
        print("Depósito de $\(cantidad) realizado. Saldo actual: $\(saldo).")
    }
 
    /// Realiza una compra si hay saldo suficiente.
    func comprar(producto: String, precio: Double) {
        guard precio > 0 else {
            print("Error: el precio debe ser positivo.")
            return
        }
        guard saldo >= precio else {
            print("Saldo insuficiente para comprar '\(producto)' ($\(precio)). Saldo actual: $\(saldo).")
            return
        }
        saldo -= precio
        historialCompras.append("\(producto) - $\(precio)")
        print("Compra exitosa: '\(producto)' por $\(precio). Saldo restante: $\(saldo).")
    }
 
    /// Retorna el saldo actual (lectura controlada sin exponer la propiedad directamente).
    func verSaldo() -> Double {
        return saldo
    }
 
    override func descripcion() {
        print("""
        ── Cliente ──────────────────────────
        Nombre   : \(nombre)
        Email    : \(email)
        Activo   : \(activo)
        Saldo    : $\(saldo)
        Compras  : \(historialCompras.isEmpty ? "ninguna" : historialCompras.joined(separator: " | "))
        """)
    }
}
 
// ============================================================
// MARK: - Demo de uso
// ============================================================
 
print("═══════════════════════════════════════")
print(" DEMO SISTEMA DE USUARIOS")
print("═══════════════════════════════════════\n")
 
// --- Usuarios base ---
let u1 = Usuario(nombre: "Carlos López", email: "carlos@mail.com", password: "secreta123")
let u2 = Usuario(nombre: "Invitado", email: "invitado@mail.com")

u1.descripcion()
u2.descripcion()
 
// Login
print("Login correcto:", u1.login(password: "secreta123"))   // true
print("Login incorrecto:", u1.login(password: "mal"))         // false
 
// Cambio de contraseña
u1.cambiarPassword(actual: "secreta123", nueva: "nueva789")
u1.cambiarPassword(actual: "nueva789", nueva: "123")          // falla: muy corta
 
// Activar / desactivar
u2.activar()
u2.desactivar()
 
print()
 
// --- Administrador ---
let admin = Administrador(
    nombre: "Ana Martínez",
    email: "ana@admin.com",
    password: "adminPass1",
    nivelAcceso: 7
)
admin.descripcion()
 
// Eliminar usuario (desactivar)
admin.eliminarUsuario(u1)
 
// Resetear contraseña
admin.resetearPassword(usuario: u1, nueva: "resetada99")
print("Login con contraseña reseteada:", u1.login(password: "resetada99"))
 
// Admin con nivel bajo intentando eliminar
let adminJunior = Administrador(
    nombre: "Becario",
    email: "becario@admin.com",
    password: "pass001",
    nivelAcceso: 2
)
adminJunior.eliminarUsuario(u2)   // denegado
adminJunior.resetearPassword(usuario: u2, nueva: "nuevaPass") // denegado
 
print()
 
// --- Cliente ---
let cliente = Cliente(
    nombre: "María García",
    email: "maria@mail.com",
    password: "clientePass",
    saldoInicial: 500.0
)
 
cliente.depositar(200.0)
cliente.comprar(producto: "Laptop", precio: 650.0)   // exitosa
cliente.comprar(producto: "Tablet", precio: 200.0)   // exitosa
cliente.comprar(producto: "Smartphone", precio: 300.0) // saldo insuficiente
cliente.depositar(-50.0)                              // falla: cantidad negativa
 
print("Saldo final:", cliente.verSaldo())
cliente.descripcion()
