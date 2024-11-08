# Keypoints
1) instructions to be executed during negative edge of the clock
2) If instructions depend on one another then do not execute them in parallel simply insert a bubble for one of them
3) Resolve RAW hazards and control hazards (incase we go for branch prediction also)
4) Can implement forwarding for RAW hazards to minimise stall cycles
5) the problem is: we have to fetch two instructins from shared memory at the same time, this problem must be resolved through:
   a. We have to put 2 PC's in order to add instructions in both pipelines simultaneously.
   b. At once we can fetch 2 instructions and store them in IR1 and IR2 (2 instruction registers)
6) The basic principle we are following is that before passing the two instructions into the two pipelines, we check whether the two instructions can be executed at the same time or not, i.e., we check for WAW, RAW, WAR all three hazards. If they are non-existent, we pass them in the two pipelines, or pass the instructions one by one in one pipeline and pass bubble(NOP) in the other.
7) We first are trying only for structural and data hazard. If time permits, also for control hazard.


ISA DEGIGN.<,br>
16 bit instruction => IR size =16 bits. <br>
No. of instructions = 16. <br>
No. of Registers = 8.<br>
memory size = 32 words<br>
pc size = 16 bit<br>
So, size of opcode = 4 bits.<br>
Immediate bit size = 1 bit.<br>
Size of register = 3 bits.<br>
Memory Addressing: Word-addressable.<br>
<br>
The instruction format is divided as follows: <br>
Opcode (4 bits)	|      I (1 bit)  	|      rd (3 bits)	|    rs1 (3 bits)      |     	rs2/imm (5 bits)
