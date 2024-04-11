## Vulnerabilidades CryptoVault:
### 1. withdraw y withdrawAll
"msg.sender.call{value: _amount}("")"
"msg.sender.call{value: amount}("")"
Primero envian y después actualizan. Lo que puede permitir a un atacante extraer más fondos de los que debería.

### 2. Delegatecall y  Fallback
Se usa Delegatecall con msg.data para llamar a la biblioteca VaultLib. Dado que la llamada  preserva el contexto, incluidos msg.sender y msg.value, se puede explotar para ejecutar funciones dentro de la biblioteca como si fuera el contrato de llamada.

### 3. Overflow y  Underflow
"accounts[msg.sender] -= _amount" no se verifica si es negativo 

## Correcciones
### Agregado Guardián de Reentrancia:
Un lock booleano previene llamadas reentrantes a funciones  como deposit, withdraw y withdrawAll.

### SafeMath: 
Todas las operaciones aritméticas ahora utilizan SafeMath  para prevenir vulnerabilidades.

### Eliminación de Delegatecall

### Reestructuración de las Funciones de Retiro: 
Las funciones withdraw y withdrawAll ahora actualizan el saldo del usuario antes de transferir Ether.