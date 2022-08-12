# super_alu
## Describtion:
The unit has a 41-bit input and a 16-bit output. It performs addition, subtraction, multiplication, power, and log2 operands. It is fully synthesizable on ISE.

## Implementation:
Input format is:
[40| op1 |38] - [37| op2 |35] - [34| op3 |32] - [31|  num1  |24] - [23|  num2  |16] - [15|  num3  |8] - [7|  num4  |0]
This is how we implemented the format:
(#num1 !op1 #num2) !op2 (#num3 !op3 #num4)

![super_alu](https://user-images.githubusercontent.com/95965466/184313956-aaee1538-96e6-4406-b861-e48e0400ae26.jpg)

