1. assembly.sol
2. graph.png (solo incluimos los tags que hacen llamada a computeSum(), al ser esta la única función que no es de inicialización dentro del contrato (runtime code)).
3. 
SLOAD: Cargar desde el storage
SSTORE: Guardar en storage

tag 10:
SSTORE: Inicializa la variable sum a 0.
tag 15:
SLOAD y SSTORE : Para actualizar el array.
tag 19:
SLOAD: Carga el tamaño del array arr para verificar la condición del bucle (i < arr.length).
tag 22: 
SLOAD: Carga el valor de arr[i] para sumarlo a sum.
tag 26:
SSTORE: Actualiza el valor de sum con sum = sum + arr[i].

CFG:
-updatedGraph.png


4.
execution cost:
2274710 gas

Podemos reducir los accesos al storage almacenando el resultado de la suma en una variable local (memoria) dentro de la función, en lugar de actualizar constantemente una variable de storage.(contractupdated.sol)

update execution cost:
2257610 gas 


