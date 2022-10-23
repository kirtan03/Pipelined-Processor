<a name="readme-top"></a>

# CSN-221 Course Project-1: Basic 5-stage Pipelined Processor

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li>
          <a href="#eda-playground">EDA Playground</a>
          <ul>
            <li><a href="#login">Login</a></li>
            <li><a href="#code">Code</a></li>
            <li><a href="#simulator-setup">Simulator Setup</a></li>
            <li><a href="#run-code">Run Code</a></li>
          </ul>
        </li>
      </ul>
    </li>
    <li><a href="#usage-example-1-fibonacci">Usage Example-1: Fibonacci</a></li>
    <li><a href="#usage-example-2-factorial">Usage Example-2: Factorial</a></li>
    <li><a href="#contributors">Contributers</a></li>
  </ol>
</details>

***

<!-- ABOUT THE PROJECT -->
## About The Project

A Basic 5-stage Pipeline Processor Simulator written in **SystemVerilog**. It can assemble and run some basic assembly code (for e.g. nth Fibonacci number finder, factorial(n) finder, etc.) written in **miniMIPS** instruction set.

Opcodes it can handle are:
* `add` for addition in register addressing mode,
* `sub` for subtraction in register addressing mode,
* `mul` for multiplication (without overflow) in register addressing mode,
* `addi` for addition in immediate addressing mode,
* `beq` for branch-on-equal instruction,
* `lw` for data-transfer from memory to register,
* `sw` for data-transfer from register to memory,
* `j` for unconditional jump.

This is [our](#contributors) submission for CSN-221 Course Project-1.

---

<!-- GETTING STARTED -->
## Getting Started

Since there is no satisfactory compiler for SystemVerilog, so unfortunately this Project has had to be run on online SystemVerilog Simulators like [Aldec Riviera Pro 2022.04](https://www.aldec.com/en/products/functional_verification/riviera-pro), which we used to make this project.

To run this project follow these steps:

### EDA Playground

This is a web application that allows users to edit, simulate, synthesize, and share their HDL code written in languages like SystemVerilog.

#### Login
* Go to https://www.edaplayground.com/
* Login by clicking on `Login` in the top-right corner

#### Code
* Copy-paste the code in `test_bench.sv` into `testbench.sv` on EDA-Playground
* Now make more files named `assembler.sv`, `IFcomp.sv`, `IDcomp.sv`, `EXcomp.sv`, `DMcomp.sv`, `WBcomp.sv` and `input.txt` in EDA-Playground by clicking in the ➕ button next to `testbench.sv` file name
* Copy-paste the corresponding codes into these newly created files
* Write the miniMIPS assembly language code in `input.txt` file

#### Simulator setup
* Click on `Tools & Simulators` in left side-bar
* Select `Aldec Riviera Pro 2022.04` from the dropdown menu

#### Run code
* Save the playground and then click `Run`
* Output will be shown in `Log` tab at the bottom

---

<!-- USAGE EXAMPLES -->
## Usage Example-1: Fibonacci

For finding nth Fibonacci number, this is the miniMIPS assembly code:
```
addi $2,$0,5
addi $3,$0,0
addi $4,$0,1
addi $5,$0,1
addi $6, $0, 1
beq $2,$5,11
add $6,$3,$4
add $3,$4,$0
add $4,$6,$0
addi $5,$5,1
j 5
*end:
```
>Note: Here `$2` is the input register and `$6` is the output register.

Now, we put this code in `input.txt` and hit `Run`.
Then output will be:
```
...
Cycle number = 54
Number of instructions executed = 34
Current CPI = 1.588235
Program Counter = 60
Register[0] = 0
Register[1] = 0
Register[2] = 5
Register[3] = 3
Register[4] = 5
Register[5] = 5
Register[6] = 5
Register[7] = 0
Register[8] = 0
Register[9] = 0
```

## Usage Example-2: Factorial

For finding the factorial of an number n, this is the miniMIPS assembly code:
```
addi $1,$0,1 
addi $2,$0,4
addi $3,$0,0
addi $6,$0,1
beq $3,$2,9
mul $6,$6,$1 
addi $1,$1,1
addi $3,$3,1
j 4
*end:
```
>Note: Here `$2` is the input register and `$6` is the output register.

Now, we put this code in `input.txt` and hit `Run`.
Then output will be:
```
...
Cycle number = 45
Number of instructions executed = 29
Current CPI = 1.551724
Program Counter = 52
Register[0] = 0
Register[1] = 5
Register[2] = 4
Register[3] = 4
Register[4] = 0
Register[5] = 0
Register[6] = 24
Register[7] = 0
Register[8] = 0
Register[9] = 0
```

---
<!-- Contributors -->
## Contributors
Contributors of this Group project:

<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://github.com/i-love-chess"><img src="https://avatars.githubusercontent.com/u/101268569?v=4" width="100px;" alt="Ashutosh Kalidas Pise (21114073)"/><br /><sub><b>Ashutosh Kalidas Pise (21114073)</b></sub>
      </td>
      <td align="center"><a href="https://github.com/ashutoshkr129"><img src="https://avatars.githubusercontent.com/u/96130203?v=4" width="100px;" alt="Ashutosh Kumar (21114021)"/><br /><sub><b>Ashutosh Kumar (21114021)</b></sub>
      </td>
      <td align="center"><a href="https://github.com/kirtan03"><img src="https://avatars.githubusercontent.com/u/95969313?v=4" width="100px;" alt="KirtanKumar VijayKumar Patel (21114051)"/><br /><sub><b>KirtanKumar VijayKumar Patel (21114051)</b></sub>
      </td>
      <td align="center"><a href="https://github.com/Magnesium12"><img src="https://avatars.githubusercontent.com/u/99383854?v=4" width="100px;" alt="Mudit Gupta (21114061)"/><br /><sub><b>Mudit Gupta (21114061)</b></sub>
      </td>
      <td align="center"><a href="https://github.com/kej-r03"><img src="https://avatars.githubusercontent.com/u/99071926?v=4" width="100px;" alt="Rishi Kejriwal (21114081)"/><br /><sub><b>Rishi Kejriwal (21114081)</b></sub>
      </td>
      <td align="center"><a href="https://github.com/rohan-kalra904"><img src="https://avatars.githubusercontent.com/u/94923525?v=4" width="100px;" alt="Rohan Kalra (21114083)"/><br /><sub><b>Rohan Kalra (21114083)</b></sub>
      </td>
    </tr>
  </tbody>
  <tfoot>

  </tfoot>
</table>