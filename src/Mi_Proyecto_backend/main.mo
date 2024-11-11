import Map "mo:map/Map";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import { thash } "mo:map/Map";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Float "mo:base/Float";

actor Finanzas {

    type Transaccion = {
        id: Text;
        tipo: Text;
        cantidad: Float;
        fecha: Text;
        usuario: Principal;
    };

    let transacciones = Map.new<Text, Transaccion>();

    public shared(msg) func agregarTransaccion(data: Transaccion) : async Result.Result<(), Text> {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            return #err("Usuario no autenticado");
        };
        if (data.cantidad <= 0) {
            return #err("La cantidad debe ser mayor que cero");
        };
        
        // Validación de campos
        if (Text.size(data.id) == 0 or Text.size(data.tipo) == 0 or Text.size(data.fecha) == 0) {
            return #err("Debes llenar todos los campos para ingresar una transacción");
        };

        // Verificar si ya existe una transacción con el mismo ID
        switch (Map.get(transacciones, thash, data.id)) {
            case (?_) {
                return #err("Ya existe una transacción con este ID");
            };
            case null {
                let transaccionConUsuario = {
                    id = data.id;
                    tipo = data.tipo;
                    cantidad = data.cantidad;
                    fecha = data.fecha;
                    usuario = caller;
                };
                Map.set(transacciones, thash, data.id, transaccionConUsuario);
                #ok(())
            };
        };
    };
    public shared(msg) func eliminarTransaccion(transaccionId: Text) : async Result.Result<(), Text> {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            return #err("Usuario no autenticado");
        };
        
        switch (Map.get(transacciones, thash, transaccionId)) {
            case (?t) {
                if (Principal.equal(t.usuario, caller)) {
                    Map.delete(transacciones, thash, transaccionId);
                    #ok(())
                } else {
                    #err("No tienes permiso para eliminar esta transacción")
                }
            };
            case null {
                #err("Transacción no encontrada")
            };
        };
    };

    public shared query(msg) func obtenerTransaccionesPorUsuario() : async Result.Result<[Transaccion], Text> {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            return #err("Usuario no autenticado");
        };
        
        let todasLasTransacciones = Iter.toArray(Map.vals(transacciones));
        let transaccionesUsuario = Array.filter(todasLasTransacciones, func (t: Transaccion) : Bool {
            Principal.equal(t.usuario, caller)
        });
        #ok(transaccionesUsuario)
    };

    public shared query(msg) func obtenerTransaccion(id: Text) : async Result.Result<Transaccion, Text> {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            return #err("Usuario no autenticado");
        };
        
        switch (Map.get(transacciones, thash, id)) {
            case (?t) {
                if (Principal.equal(t.usuario, caller)) {
                    #ok(t)
                } else {
                    #err("No tienes permiso para ver esta transacción")
                }
            };
            case null { #err("Transacción no encontrada") };
        };
    };

    public shared(msg) func actualizarTransaccion(id: Text, nuevaData: Transaccion) : async Result.Result<(), Text> {
        let caller = msg.caller;
        if (Principal.isAnonymous(caller)) {
            return #err("Usuario no autenticado");
        };
        if (nuevaData.cantidad <= 0) {
            return #err("La cantidad debe ser mayor que cero");
        };

        // Validación de campos
        if (Text.size(nuevaData.tipo) == 0 or Text.size(nuevaData.fecha) == 0) {
            return #err("Debes llenar todos los campos para actualizar la transacción");
        };
        
        switch (Map.get(transacciones, thash, id)) {
            case (?t) {
                if (Principal.equal(t.usuario, caller)) {
                    let transaccionActualizada = {
                        id = id;
                        tipo = nuevaData.tipo;
                        cantidad = nuevaData.cantidad;
                        fecha = nuevaData.fecha;
                        usuario = caller;
                    };
                    Map.set(transacciones, thash, id, transaccionActualizada);
                    #ok(())
                } else {
                    #err("No tienes permiso para actualizar esta transacción")
                }
            };
            case null {
                #err("Transacción no encontrada")
            };
        };
    };
}
