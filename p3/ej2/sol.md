
|--------------addClient------------------------------------------------|------Execution cost-----------|
| Name         | Amount    |          Address                           | PiggyArray   | PiggyMapping   |
|--------------|-----------|--------------------------------------------|--------------|----------------|
| Huey         | 10 ETH    | 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB | 75974        |     45929      |
| Dewey        | 20 ETH    | 0x617F2E2fD72FD9D5503197092aC168c91465E7f2 | 78500        |     45929      |
| Louie        | 30 ETH    | 0x6f8dFBe87982bBC25E2C5b718EdaD940F4fe2976 | 81026        |     45929      |
|--------------|-----------|--------------------------------------------|--------------|----------------|


|--------------getBalance-----------------------------------|------Execution cost-----------|
| Name         |          Address                           | PiggyArray   | PiggyMapping   |
|--------------|--------------------------------------------|--------------|----------------|
| Juanito      | 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB | 7202         |     2468       |
| Jaimito      | 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 | 9728         |     2468       |
| Silvestre    | 0x6f8dFBe87982bBC25E2C5b718EdaD940F4fe2976 | 14780        |     2468       |
|--------------|--------------------------------------------|--------------|----------------|


Explanation:
- The PiggyArray contract is more efficient than the PiggyMapping contract in terms of execution cost.

The gas cost associated with using a PiggyMapping is lower  regardless of the number of clients because accessing a mapping's value by key is a direct operation. In contrast, using a PiggyArray might require iterating over the array to find a specific client's balance, leading to higher gas costs as the number of clients increases.

With 100 or 1.000 Clients: The difference in gas costs between PiggyArray and PiggyMapping become more pronounced. PiggyArray's cost would significantly increase due to the need for iteration, whereas PiggyMapping's cost would remain relatively stable.