assembly {

.code
  PUSH 80			contract lab6 {\r\n    uint[] ...
  PUSH 40			contract lab6 {\r\n    uint[] ...
  MSTORE 			contract lab6 {\r\n    uint[] ...
  CALLVALUE 			contract lab6 {\r\n    uint[] ...
  DUP1 			contract lab6 {\r\n    uint[] ...
  ISZERO 			contract lab6 {\r\n    uint[] ...
  PUSH [tag] 1			contract lab6 {\r\n    uint[] ...
  JUMPI 			contract lab6 {\r\n    uint[] ...
  PUSH 0			contract lab6 {\r\n    uint[] ...
  DUP1 			contract lab6 {\r\n    uint[] ...
  REVERT 			contract lab6 {\r\n    uint[] ...
tag 1			contract lab6 {\r\n    uint[] ...
  JUMPDEST 			contract lab6 {\r\n    uint[] ...
  POP 			contract lab6 {\r\n    uint[] ...
  PUSH #[$] 0000000000000000000000000000000000000000000000000000000000000000			contract lab6 {\r\n    uint[] ...
  DUP1 			contract lab6 {\r\n    uint[] ...
  PUSH [$] 0000000000000000000000000000000000000000000000000000000000000000			contract lab6 {\r\n    uint[] ...
  PUSH 0			contract lab6 {\r\n    uint[] ...
  CODECOPY 			contract lab6 {\r\n    uint[] ...
  PUSH 0			contract lab6 {\r\n    uint[] ...
  RETURN 			contract lab6 {\r\n    uint[] ...
.data
  0:
    .code
      PUSH 80			contract lab6 {\r\n    uint[] ...
      PUSH 40			contract lab6 {\r\n    uint[] ...
      MSTORE 			contract lab6 {\r\n    uint[] ...
      CALLVALUE 			contract lab6 {\r\n    uint[] ...
      DUP1 			contract lab6 {\r\n    uint[] ...
      ISZERO 			contract lab6 {\r\n    uint[] ...
      PUSH [tag] 1			contract lab6 {\r\n    uint[] ...
      JUMPI 			contract lab6 {\r\n    uint[] ...
      PUSH 0			contract lab6 {\r\n    uint[] ...
      DUP1 			contract lab6 {\r\n    uint[] ...
      REVERT 			contract lab6 {\r\n    uint[] ...
    tag 1			contract lab6 {\r\n    uint[] ...
      JUMPDEST 			contract lab6 {\r\n    uint[] ...
      POP 			contract lab6 {\r\n    uint[] ...
      PUSH 4			contract lab6 {\r\n    uint[] ...
      CALLDATASIZE 			contract lab6 {\r\n    uint[] ...
      LT 			contract lab6 {\r\n    uint[] ...
      PUSH [tag] 2			contract lab6 {\r\n    uint[] ...
      JUMPI 			contract lab6 {\r\n    uint[] ...
      PUSH 0			contract lab6 {\r\n    uint[] ...
      CALLDATALOAD 			contract lab6 {\r\n    uint[] ...
      PUSH E0			contract lab6 {\r\n    uint[] ...
      SHR 			contract lab6 {\r\n    uint[] ...
      DUP1 			contract lab6 {\r\n    uint[] ...
      PUSH 4A7DD523			contract lab6 {\r\n    uint[] ...
      EQ 			contract lab6 {\r\n    uint[] ...
      PUSH [tag] 3			contract lab6 {\r\n    uint[] ...
      JUMPI 			contract lab6 {\r\n    uint[] ...
      DUP1 			contract lab6 {\r\n    uint[] ...
      PUSH C2A970D1			contract lab6 {\r\n    uint[] ...
      EQ 			contract lab6 {\r\n    uint[] ...
      PUSH [tag] 4			contract lab6 {\r\n    uint[] ...
      JUMPI 			contract lab6 {\r\n    uint[] ...
    tag 2			contract lab6 {\r\n    uint[] ...
      JUMPDEST 			contract lab6 {\r\n    uint[] ...
      PUSH 0			contract lab6 {\r\n    uint[] ...
      DUP1 			contract lab6 {\r\n    uint[] ...
      REVERT 			contract lab6 {\r\n    uint[] ...
    tag 3			function generate(uint n) exte...
      JUMPDEST 			function generate(uint n) exte...
      PUSH [tag] 5			function generate(uint n) exte...
      PUSH 4			function generate(uint n) exte...
      DUP1 			function generate(uint n) exte...
      CALLDATASIZE 			function generate(uint n) exte...
      SUB 			function generate(uint n) exte...
      DUP2 			function generate(uint n) exte...
      ADD 			function generate(uint n) exte...
      SWAP1 			function generate(uint n) exte...
      PUSH [tag] 6			function generate(uint n) exte...
      SWAP2 			function generate(uint n) exte...
      SWAP1 			function generate(uint n) exte...
      PUSH [tag] 7			function generate(uint n) exte...
      JUMP 			function generate(uint n) exte...
    tag 6			function generate(uint n) exte...
      JUMPDEST 			function generate(uint n) exte...
      PUSH [tag] 8			function generate(uint n) exte...
      JUMP 			function generate(uint n) exte...
    tag 5			function generate(uint n) exte...
      JUMPDEST 			function generate(uint n) exte...
      STOP 			function generate(uint n) exte...
    tag 4			function computeSum() external...
      JUMPDEST 			function computeSum() external...
      PUSH [tag] 9			function computeSum() external...
      PUSH [tag] 10			function computeSum() external...
      JUMP 			function computeSum() external...
    tag 9			function computeSum() external...
      JUMPDEST 			function computeSum() external...
      STOP 			function computeSum() external...
    tag 8			function generate(uint n) exte...
      JUMPDEST 			function generate(uint n) exte...
      PUSH 0			uint i
    tag 12			for (uint i = 0; i < n; i++) {...
      JUMPDEST 			for (uint i = 0; i < n; i++) {...
      DUP2 			n
      DUP2 			i
      LT 			i < n
      ISZERO 			for (uint i = 0; i < n; i++) {...
      PUSH [tag] 13			for (uint i = 0; i < n; i++) {...
      JUMPI 			for (uint i = 0; i < n; i++) {...
      PUSH 0			arr
      DUP2 			i
      DUP3 			i
      PUSH [tag] 15			i*i
      SWAP2 			i*i
      SWAP1 			i*i
      PUSH [tag] 16			i*i
      JUMP 			i*i
    tag 15			i*i
      JUMPDEST 			i*i
      SWAP1 			arr.push(i*i)
      DUP1 			arr.push(i*i)
      PUSH 1			arr.push(i*i)
      DUP2 			arr.push(i*i)
      SLOAD 			arr.push(i*i)
      ADD 			arr.push(i*i)
      DUP1 			arr.push(i*i)
      DUP3 			arr.push(i*i)
      SSTORE 			arr.push(i*i)
      DUP1 			arr.push(i*i)
      SWAP2 			arr.push(i*i)
      POP 			arr.push(i*i)
      POP 			arr.push(i*i)
      PUSH 1			arr.push(i*i)
      SWAP1 			arr.push(i*i)
      SUB 			arr.push(i*i)
      SWAP1 			arr.push(i*i)
      PUSH 0			arr.push(i*i)
      MSTORE 			arr.push(i*i)
      PUSH 20			arr.push(i*i)
      PUSH 0			arr.push(i*i)
      KECCAK256 			arr.push(i*i)
      ADD 			arr.push(i*i)
      PUSH 0			arr.push(i*i)
      SWAP1 			arr.push(i*i)
      SWAP2 			arr.push(i*i)
      SWAP1 			arr.push(i*i)
      SWAP2 			arr.push(i*i)
      SWAP1 			arr.push(i*i)
      SWAP2 			arr.push(i*i)
      POP 			arr.push(i*i)
      SSTORE 			arr.push(i*i)
      DUP1 			i++
      DUP1 			i++
      PUSH 1			i++
      ADD 			i++
      SWAP2 			i++
      POP 			i++
      POP 			i++
      PUSH [tag] 12			for (uint i = 0; i < n; i++) {...
      JUMP 			for (uint i = 0; i < n; i++) {...
    tag 13			for (uint i = 0; i < n; i++) {...
      JUMPDEST 			for (uint i = 0; i < n; i++) {...
      POP 			for (uint i = 0; i < n; i++) {...
      POP 			function generate(uint n) exte...
      JUMP 			function generate(uint n) exte...
    tag 10			function computeSum() external...
      JUMPDEST 			function computeSum() external...
      PUSH 0			0
      PUSH 1			sum
      DUP2 			sum = 0
      SWAP1 			sum = 0
      SSTORE 			sum = 0
      POP 			sum = 0
      PUSH 0			uint i
    tag 19			for (uint i = 0; i < arr.lengt...
      JUMPDEST 			for (uint i = 0; i < arr.lengt...
      PUSH 0			arr
      DUP1 			arr.length
      SLOAD 			arr.length
      SWAP1 			arr.length
      POP 			arr.length
      DUP2 			i
      LT 			i < arr.length
      ISZERO 			for (uint i = 0; i < arr.lengt...
      PUSH [tag] 20			for (uint i = 0; i < arr.lengt...
      JUMPI 			for (uint i = 0; i < arr.lengt...
      PUSH 0			arr
      DUP2 			i
      DUP2 			arr[i]
      SLOAD 			arr[i]
      DUP2 			arr[i]
      LT 			arr[i]
      PUSH [tag] 22			arr[i]
      JUMPI 			arr[i]
      PUSH [tag] 23			arr[i]
      PUSH [tag] 24			arr[i]
      JUMP 			arr[i]
    tag 23			arr[i]
      JUMPDEST 			arr[i]
    tag 22			arr[i]
      JUMPDEST 			arr[i]
      SWAP1 			arr[i]
      PUSH 0			arr[i]
      MSTORE 			arr[i]
      PUSH 20			arr[i]
      PUSH 0			arr[i]
      KECCAK256 			arr[i]
      ADD 			arr[i]
      SLOAD 			arr[i]
      PUSH 1			sum
      SLOAD 			sum
      PUSH [tag] 26			sum + arr[i]
      SWAP2 			sum + arr[i]
      SWAP1 			sum + arr[i]
      PUSH [tag] 27			sum + arr[i]
      JUMP 			sum + arr[i]
    tag 26			sum + arr[i]
      JUMPDEST 			sum + arr[i]
      PUSH 1			sum
      DUP2 			sum = sum + arr[i]
      SWAP1 			sum = sum + arr[i]
      SSTORE 			sum = sum + arr[i]
      POP 			sum = sum + arr[i]
      DUP1 			i++
      DUP1 			i++
      PUSH 1			i++
      ADD 			i++
      SWAP2 			i++
      POP 			i++
      POP 			i++
      PUSH [tag] 19			for (uint i = 0; i < arr.lengt...
      JUMP 			for (uint i = 0; i < arr.lengt...
    tag 20			for (uint i = 0; i < arr.lengt...
      JUMPDEST 			for (uint i = 0; i < arr.lengt...
      POP 			for (uint i = 0; i < arr.lengt...
      JUMP 			function computeSum() external...
    tag 29			] arr;\r\n    uint sum;\r\n   ...
      JUMPDEST 			] arr;\r\n    uint sum;\r\n   ...
      PUSH 0			 
      DUP1 			 
      REVERT 			+) {\r\n      
    tag 31			; i++) {\r\n            sum = ...
      JUMPDEST 			; i++) {\r\n            sum = ...
      PUSH 0			[i];\r\n 
      DUP2 			
      SWAP1 			   }\r\n}
      POP 			   }\r\n}
      SWAP2 			; i++) {\r\n            sum = ...
      SWAP1 			; i++) {\r\n            sum = ...
      POP 			; i++) {\r\n            sum = ...
      JUMP 			; i++) {\r\n            sum = ...
    tag 32			
      JUMPDEST 			
      PUSH [tag] 41			
      DUP2 			
      PUSH [tag] 31			
      JUMP 			
    tag 41			
      JUMPDEST 			
      DUP2 			
      EQ 			
      PUSH [tag] 42			
      JUMPI 			
      PUSH 0			
      DUP1 			
      REVERT 			
    tag 42			
      JUMPDEST 			
      POP 			
      JUMP 			
    tag 33			
      JUMPDEST 			
      PUSH 0			
      DUP2 			
      CALLDATALOAD 			
      SWAP1 			
      POP 			
      PUSH [tag] 44			
      DUP2 			
      PUSH [tag] 32			
      JUMP 			
    tag 44			
      JUMPDEST 			
      SWAP3 			
      SWAP2 			
      POP 			
      POP 			
      JUMP 			
    tag 7			
      JUMPDEST 			
      PUSH 0			
      PUSH 20			
      DUP3 			
      DUP5 			
      SUB 			
      SLT 			
      ISZERO 			
      PUSH [tag] 46			
      JUMPI 			
      PUSH [tag] 47			
      PUSH [tag] 29			
      JUMP 			
    tag 47			
      JUMPDEST 			
    tag 46			
      JUMPDEST 			
      PUSH 0			
      PUSH [tag] 48			
      DUP5 			
      DUP3 			
      DUP6 			
      ADD 			
      PUSH [tag] 33			
      JUMP 			
    tag 48			
      JUMPDEST 			
      SWAP2 			
      POP 			
      POP 			
      SWAP3 			
      SWAP2 			
      POP 			
      POP 			
      JUMP 			
    tag 34			
      JUMPDEST 			
      PUSH 4E487B7100000000000000000000000000000000000000000000000000000000			
      PUSH 0			
      MSTORE 			
      PUSH 11			
      PUSH 4			
      MSTORE 			
      PUSH 24			
      PUSH 0			
      REVERT 			
    tag 16			
      JUMPDEST 			
      PUSH 0			
      PUSH [tag] 51			
      DUP3 			
      PUSH [tag] 31			
      JUMP 			
    tag 51			
      JUMPDEST 			
      SWAP2 			
      POP 			
      PUSH [tag] 52			
      DUP4 			
      PUSH [tag] 31			
      JUMP 			
    tag 52			
      JUMPDEST 			
      SWAP3 			
      POP 			
      DUP3 			
      DUP3 			
      MUL 			
      PUSH [tag] 53			
      DUP2 			
      PUSH [tag] 31			
      JUMP 			
    tag 53			
      JUMPDEST 			
      SWAP2 			
      POP 			
      DUP3 			
      DUP3 			
      DIV 			
      DUP5 			
      EQ 			
      DUP4 			
      ISZERO 			
      OR 			
      PUSH [tag] 54			
      JUMPI 			
      PUSH [tag] 55			
      PUSH [tag] 34			
      JUMP 			
    tag 55			
      JUMPDEST 			
    tag 54			
      JUMPDEST 			
      POP 			
      SWAP3 			
      SWAP2 			
      POP 			
      POP 			
      JUMP 			
    tag 24			
      JUMPDEST 			
      PUSH 4E487B7100000000000000000000000000000000000000000000000000000000			
      PUSH 0			
      MSTORE 			
      PUSH 32			
      PUSH 4			
      MSTORE 			
      PUSH 24			
      PUSH 0			
      REVERT 			
    tag 27			
      JUMPDEST 			
      PUSH 0			
      PUSH [tag] 58			
      DUP3 			
      PUSH [tag] 31			
      JUMP 			
    tag 58			
      JUMPDEST 			
      SWAP2 			
      POP 			
      PUSH [tag] 59			
      DUP4 			
      PUSH [tag] 31			
      JUMP 			
    tag 59			
      JUMPDEST 			
      SWAP3 			
      POP 			
      DUP3 			
      DUP3 			
      ADD 			
      SWAP1 			
      POP 			
      DUP1 			
      DUP3 			
      GT 			
      ISZERO 			
      PUSH [tag] 60			
      JUMPI 			
      PUSH [tag] 61			
      PUSH [tag] 34			
      JUMP 			
    tag 61			
      JUMPDEST 			
    tag 60			
      JUMPDEST 			
      SWAP3 			
      SWAP2 			
      POP 			
      POP 			
      JUMP 			
    .data
}
