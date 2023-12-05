library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
	port(clock,reset:in std_logic);
end entity CPU;

architecture bhv of CPU is 
component controller is
	port (ir:in std_logic_vector(15 downto 0);
			clock,z:in std_logic;
			ir_write,rf_a1_sel,mem_addr_sel,rf_write,t_pc_write,t1_write,t2_write,mem_write,se_in_sel,se_op_sel:out std_logic;
			alu_a_sel,alu_b_sel,rf_a3_sel:out std_logic_vector(1 downto 0);
			rf_d3_sel:out std_logic_vector(2 downto 0);
			out_state,out_op:out std_logic_vector(3 downto 0));
end component controller;


component DataPath is 
port (	reset,ir_write,rf_a1_sel,mem_addr_sel,rf_write,t_pc_write,t1_write,t2_write,mem_write,se_in_sel,se_op_sel:in std_logic;
			alu_a_sel,alu_b_sel,rf_a3_sel:in std_logic_vector(1 downto 0);
			rf_d3_sel:in std_logic_vector(2 downto 0); 
			clock: in std_logic;
			out_state,out_op:in std_logic_vector(3 downto 0);

			
			ir_data: out std_logic_vector(15 downto 0); 
			zero_flag:out std_logic);
			
end component DataPath;


signal ir_writea,rf_a1_sela,mem_addr_sela,rf_writea,t_pc_writea,t1_writea,t2_writea,mem_writea,se_in_sela,se_op_sela: std_logic;
signal alu_a_sela,alu_b_sela,rf_a3_sela: std_logic_vector(1 downto 0);
signal rf_d3_sela: std_logic_vector(2 downto 0); 

signal	out_statea,out_opa:std_logic_vector(3 downto 0);			
signal	ir_dataa:  std_logic_vector(15 downto 0); 
signal	zero_flaga: std_logic;
begin

controller_1: controller port map(ir_dataa,clock,zero_flaga,ir_writea,rf_a1_sela,mem_addr_sela,rf_writea,t_pc_writea,t1_writea,t2_writea,mem_writea,se_in_sela,se_op_sela,
												alu_a_sela,alu_b_sela,rf_a3_sela,rf_d3_sela,out_statea,out_opa);
												
data_path_1:DataPath port map(reset,ir_writea,rf_a1_sela,mem_addr_sela,rf_writea,t_pc_writea,t1_writea,t2_writea,mem_writea,se_in_sela,se_op_sela,
										alu_a_sela,alu_b_sela,rf_a3_sela,rf_d3_sela,clock,out_statea,out_opa,
										ir_dataa,zero_flaga);
										
end architecture bhv;	