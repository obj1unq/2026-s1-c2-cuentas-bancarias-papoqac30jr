object casa {
    var cuentaBancaria = cuentaCorriente
    var gastos = 0
    var porcentajeViveres = 0
    var montoPorReparaciones = 0
    var estrategiaDeMantenimiento = estrategiaMinimaEIndispensable

    method gasto(dinero) {
        cuentaBancaria.extraer(dinero)
        gastos = gastos + dinero
    }

    method cuentaBancaria(_cuentaBancaria) {
        cuentaBancaria = _cuentaBancaria
    }

    method cambiarMes() {
        gastos = 0
        self.mantenimiento()
    }

    method gastado() {
        return gastos
    }

    method vivereRoto(monto) {
        montoPorReparaciones = montoPorReparaciones + monto
    }

    method comprarViveres(porcentaje , calidad) {
        if (porcentajeViveres + porcentaje < 100) {
        porcentajeViveres = porcentajeViveres + porcentaje
        gastos = gastos + porcentaje * calidad
        cuentaBancaria.extraer(porcentaje * calidad)
        } else {
            self.error("los viveres que desea comprar excede la cantidad maxima de viveres en la casa")
        }
    }

    method reparaciones() {
       self.gasto(montoPorReparaciones)
       montoPorReparaciones = 0
    }

    method hayViveresSuficientes() {
        return porcentajeViveres >= 40
    }

    method hayQueReparar() {
        return montoPorReparaciones > 0
    }

    method estaEnOrden() {
        return self.hayViveresSuficientes() and not self.hayQueReparar()
    }

    method porcentajeViveres(_porcentajeViveres) {
        porcentajeViveres = _porcentajeViveres
    }

    method montoPorReparaciones(_montoPorReparaciones) {
        montoPorReparaciones = _montoPorReparaciones
    }

    method porcentajeViveres() {
        return porcentajeViveres
    }

    method montoPorReparaciones() {
        return montoPorReparaciones
    }

    method mantenimiento() {
        estrategiaDeMantenimiento.realizarMantenimiento()
    }

    method estrategiaDeMantenimiento(_estrategiaDeMantenimiento) {
        estrategiaDeMantenimiento = _estrategiaDeMantenimiento
    }
}

object cuentaCorriente {
    var saldo = 0

    method saldo() {
        return saldo
    }
    
    method saldo(_saldo) {
        saldo = _saldo
    }

    method extraer(dinero) {
        saldo = saldo - dinero
    }

    method depositar(dinero) {
        saldo = saldo + dinero
    }   
}

object cuentaConGastos {
    var saldo = 0
    var costoPorOperacion = 0

    method saldo() {
        return saldo
    }

    method saldo(_saldo) {
        saldo = saldo - _saldo
    }   

    method extraer(dinero) {
        saldo = saldo - dinero
    }

    method depositar(dinero) {
        self.puedeDepositar(dinero)
        saldo = saldo + dinero - costoPorOperacion
    }   

    method puedeDepositar(dinero) {
        if (dinero <= costoPorOperacion) {
            self.error("No hay suficientes fondos para realizar el deposito")
        }
    }

    method costoPorOperacion(_costoPorOperacion) {
        costoPorOperacion = _costoPorOperacion
    }
}

object cuentaCombinada {
    var cuentaPrincipal = cuentaCorriente
    var cuentaSecundaria = cuentaConGastos

    method depositar(dinero) {
        cuentaPrincipal.depositar(dinero)
    }

    method extraer(dinero) {
        const dineroExtraido = 0.max(dinero - cuentaPrincipal.saldo())
        if (self.saldo() >= dinero) {
           self.extraerTodoLoPosible(dinero)
           self.extraerLoQueFalta(dineroExtraido)
        } else {
            self.error("No hay suficientes fondos para realizar la extraccion")
        }
    }

    method saldo() {
        return 0.max(cuentaPrincipal.saldo()) + 0.max(cuentaSecundaria.saldo())
    }

    method extraerTodoLoPosible(dinero) {
        if(cuentaPrincipal.saldo() >= dinero) {
            cuentaPrincipal.extraer(dinero)
        } else {
            cuentaPrincipal.extraer(cuentaPrincipal.saldo())
        }
    }

    method extraerLoQueFalta(dinero) {
        if(dinero > 0) {
            cuentaSecundaria.extraer(dinero)
        }
    }

    method cuentaPrincipal(_cuentaPrincipal) {
        cuentaPrincipal = _cuentaPrincipal
    }

    method cuentaSecundaria(_cuentaSecundaria) {
    cuentaSecundaria = _cuentaSecundaria
    }
}

object estrategiaMinimaEIndispensable {
    var viveresSuficientes = 0
    var calidad = 0

    method realizarMantenimiento() {
        if(not casa.hayViveresSuficientes()) {
            viveresSuficientes = viveresSuficientes + casa.porcentajeViveres()
            casa.comprarViveres(40 - viveresSuficientes , calidad)
        } else {
            self.error("la cantidad de viveres en la casa excede la cantidad maxima de esta estrategia.")
        }
    }

    method calidad() {
        return calidad
    }

    method calidad(_calidad) {
        calidad = _calidad
    }
}

object estrategiaFull {
    var cantidadDeViveres = 0
    method realizarMantenimiento() {
        self.mantenimientoCompra()
        self.mantenimientoReparaciones()
    }

    method mantenimientoCompra() {
        if (casa.estaEnOrden()) {
            cantidadDeViveres = casa.porcentajeViveres()
            casa.comprarViveres(100 - cantidadDeViveres , 5)
        } else {
            self.comprarViveresSiEsNecesario(40 - cantidadDeViveres , 5)
        }
    }

    method comprarViveresSiEsNecesario(monto , calidad) {
        if(not monto >= 0) {
            casa.comprarViveres(monto , calidad)
        }
    }

    method mantenimientoReparaciones() {
        casa.reparaciones()
    }
}