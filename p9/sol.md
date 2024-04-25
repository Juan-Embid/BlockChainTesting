EX.1:
  p1:
    REMIX infinite
    GASTAP

      Memory UB for p1(): 15
      Opcodes UB for p1(): 2381+6453*nat(arr/2+1/2)

  p2:
    REMIX infinite
    GASTAP

      Memory UB for p2(): 3*max([nat(arr)+4+2])+pow(max([nat(arr)+4+2]),2)/512
      Opcodes UB for p2(): 6673+2150*nat(arr-1/32)

  p3:
    REMIX 122
    GASTAP

      Memory UB for p3(): 9
      Opcodes UB for p3(): 126

  GASTAP proporciona métricas precisas, podría ser una herramienta poderosa, especialmente en entornos de alto riesgo, donde las ineficiencias y errores pueden tener implicaciones significativas.

EX.2:

  1.
    Memory UB for powers(): 9
    Opcodes UB for powers(): 2261+26471*nat(arr)

  2.
    pragma solidity ^0.8.0;
    contract ReduceStorageAccess {
        uint[] public arr;

        function powers() public {
            uint len = arr.length;
            for (uint i = 0; i < len; i++) {
                uint val = arr[i];
                arr[i] = val * val;
            }
        }
    }

  3.
    Memory UB for powers(): 9
    Opcodes UB for powers(): 31235

    El  original tenía un límite de operación de 2261 26471 * nat(arr), lo que significa que los códigos de operación aumentan con el tamaño de la matriz arr. Por el contrario, el contrato optimizado tiene códigos de operación UB fijos de 31235 independientemente del tamaño de la matriz.