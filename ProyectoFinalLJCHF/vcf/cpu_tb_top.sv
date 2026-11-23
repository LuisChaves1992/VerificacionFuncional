module cpu_tb_top (
    input logic clk,
    input logic rst,
    input logic [31:0] Instr
);

    logic [4:0]  rs1;
	logic [4:0]  rs2;
	logic [4:0]  rd;
	logic [11:0] imm;
	logic [6:0]  opcode;
	logic [2:0]  funct3;
	logic [6:0]  funct7;

	assign rd  = Instr[11:7];
	assign rs1 = Instr[19:15];
	assign rs2 = Instr[24:20];
	assign imm = Instr[31:20];
	assign opcode = Instr[6:0];
	assign funct3 = Instr[14:12];
	assign funct7 = Instr[31:25];

    // Outputs from reference behavioral model
    logic [31:0] result_spec;
    logic [31:0] pc_spec;

    // Outputs from implementation RTL
    logic [31:0] result_impl;
    logic [31:0] pc_impl;

    // Instantiate Reference Model
    cpu_behavioral u_spec (
        .clk     (clk),
        .rst     (rst),
        .Instr   (Instr),
        .PC      (pc_spec),
        .Result (result_spec)
    );                                                                       
                                                                             
    // Instantiate RTL Implementation
    cpu u_impl (
        .clk     (clk),
        .rst     (rst),
        .Instr   (Instr),
        .PC      (pc_impl),
        .Result (result_impl)
    );

    // Formal Assertions: Check that outputs match identically
    always_ff @(posedge clk) begin
        assume property(
            (Instr == {imm,rs1,3'b000,rd,7'b0010011}) ||  //ADDI
            (Instr == {7'b0000000,rs2,rs1,3'b000,rd,7'b0110011}) ||  //ADD
            (Instr == {7'b0100000,rs2,rs1,3'b000,rd,7'b0110011}) ||  //SUB
            (Instr == {7'b0000000,rs2,rs1,3'b111,rd,7'b0110011}) ||  //AND
            (Instr == {7'b0000000,rs2,rs1,3'b110,rd,7'b0110011}) ||  //OR
            (Instr == {7'b0000000,rs2,rs1,3'b010,rd,7'b0110011})     //SLT
            
        );
        if (!rst) begin
            assert_result_match: assert property(result_impl == result_spec)
                else $error("Mismatch: RTL out = %0h, Behavioral out = %0h", result_impl, result_spec);
                
            assert_pc_match: assert property(pc_impl == pc_spec)
                else $error("Mismatch: RTL zero = %0b, Behavioral zero = %0b", pc_impl, pc_spec);
        end
    end

endmodule