module decode_unit (
    input wire clk,
    input wire reset,
    input wire stall,                               // Stall signal
    input wire is_branch_taken,                     // Branch taken signal
    input wire [15:0] instr,                        // 16-bit instruction
    output reg [4:0] imm,                           // 5-bit immediate value
    output reg [3:0] opcode,                        // 4-bit Opcode
    output reg [15:0] branch_target,                // Calculated branch target
    output reg [15:0] op1, op2,                     // Operand values
    output reg imm_flag                             // Immediate flag
);

    // Internal registers
    reg [15:0] value_rs1, value_rs2;                // Registers to store rs1 and rs2 values
    reg [2:0] rd, rs1, rs2;                         // Register fields

    // Memory array to hold values from hex file
    reg [15:0] reg_file [0:7];                      // Register file memory (16 registers)

    // Load the hex file at the start
    initial begin
        $readmemh("reg_file.hex", reg_file);         // Load values from hex file
    end

    // Decode logic triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            opcode <= 4'h0;                         // NOP instruction
            rd <= 3'h0;
            rs1 <= 3'h0;
            rs2 <= 3'h0;
            imm <= 5'h00;
            branch_target <= 16'h0;
            imm_flag <= 0;
            op1 <= 16'h0;
            op2 <= 16'h0;
        end else if (is_branch_taken) begin
            // Handle flush (invalidate current instruction)
            opcode <= 4'h0;                         // NOP
            rd <= 3'h0;
            rs1 <= 3'h0;
            rs2 <= 3'h0;
            imm <= 5'h00;
            op1 <= 16'h0;
            op2 <= 16'h0;
        end else if (!stall) begin
            // Decode the instruction when not stalled
            opcode <= instr[15:12];                 // Extract 4-bit opcode
            imm_flag <= instr[11];                  // Extract immediate flag (bit 11)
            rd <= instr[10:8];                      // Extract rd (3-bit)
            rs1 <= instr[7:5];                      // Extract rs1 (3-bit)
            
            if (instr[11]) begin
                // If the instruction uses immediate
                rs2 <= 3'h0;
                imm <= instr[4:0];                  // Extract 5-bit immediate
                value_rs1 <= reg_file[rs1];         // Load rs1 value from register file
                value_rs2 <= 16'h0;                 // No rs2 for immediate type
            end else begin
                // If the instruction uses rs2
                rs2 <= instr[4:2];                  // Extract 3-bit rs2 field
                value_rs1 <= reg_file[rs1];         // Load rs1 value from register file
                value_rs2 <= reg_file[rs2];         // Load rs2 value from register file
                imm <= 5'h0;
            end

            // Calculate branch target if the instruction is a branch
            if (instr[15:12] == 4'hC) begin  // Assuming opcode '1100' (0xC) is branch
                branch_target <= {{11{instr[4]}}, instr[4:0]} << 2;  // Extend and shift
            end else begin
                branch_target <= 16'h0;  // No branch target if it's not a branch
            end
        end
        if (instr[11]) begin
            op1 <= value_rs1;             // Operand 1 from rs1
            op2 <= {10'b0, imm};          // Operand 2 from immediate value
        end else begin
            op1 <= value_rs1;             // Operand 1 from rs1
            op2 <= value_rs2;             // Operand 2 from rs2
        end
    end

    // Operand assignment
endmodule
