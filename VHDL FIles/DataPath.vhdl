library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataPath is 
port (	reset,ir_write,rf_a1_sel,mem_addr_sel,rf_write,t_pc_write,t1_write,t2_write,mem_write,se_in_sel,se_op_sel:in std_logic;
			alu_a_sel,alu_b_sel,rf_a3_sel:in std_logic_vector(1 downto 0);
			rf_d3_sel:in std_logic_vector(2 downto 0); 
			clock: in std_logic;
			out_state,out_op:in std_logic_vector(3 downto 0);
			
			ir_data: out std_logic_vector(15 downto 0); 
			zero_flag:out std_logic);
			--Reg1_data,Reg2_data,Reg7_data : out std_logic_vector(15 downto 0));
			
end entity DataPath;

architecture bhv of DataPath is

signal ALU_Ain, ALU_Bin, ALU_Cout,mem_addr_in,mem_dataOut: std_logic_vector(15 downto 0);
signal RF_D3in, RF_D1out, RF_D2out: std_logic_vector(15 downto 0);
signal IRout, T1out, T2out, Tpcout: std_logic_vector(15 downto 0);
signal SEout: std_logic_vector(15 downto 0);
signal LSout: std_logic_vector(15 downto 0);
signal ALU_zero: std_logic;
signal RF_A1in, RF_A2in, RF_A3in: std_logic_vector(2 downto 0);


component Memory is 
    port (Mem_Add,Mem_Data_in :in std_logic_vector(15 downto 0);
          Mem_write,clock,reset :in std_logic;
		    Mem_Data_out :out std_logic_vector (15 downto 0));
end component Memory;

component left_shifter is 
	port (in_ls:in std_logic_vector(15 downto 0);
			out_ls:out std_logic_vector(15 downto 0));
end component left_shifter;

component sign_extender is 
	port (in_9:in std_logic_vector(8 downto 0);
			in_6:in std_logic_vector(5 downto 0);
			op_sel,in_sel:in std_logic;
			outp:out std_logic_vector(15 downto 0));
end component sign_extender;

component alu is
	port (alu_s3,alu_op: in std_logic_vector(3 downto 0);
			alu_a,alu_b: in std_logic_vector(15 downto 0);
			alu_c: out std_logic_vector(15 downto 0);
			alu_zero: out std_logic);
end component alu;

--component Memory is 
--    port (Mem_Add,Mem_Data_in :in std_logic_vector(15 downto 0);
--          Mem_write,Clock :in std_logic;
--		    Mem_Data_out :out std_logic_vector (15 downto 0));
--end component Memory;

component Register_File is
    port (RF_A1,RF_A2,RF_A3: in std_logic_vector(2 downto 0);
          RF_D3: in std_logic_vector(15 downto 0);
          RF_WE,Clock,reset: in std_logic;
          RF_D1,RF_D2: out std_logic_vector(15 downto 0));
end component Register_File;

component Register_16bit is 
       port (Data_in : in std_logic_vector (15 downto 0);
             Write_en,Clock,reset : in std_logic;
		       Data_out : out std_logic_vector (15 downto 0));
end component Register_16bit;

begin

ALU_1: alu port map (out_state, out_op, ALU_Ain, ALU_Bin, ALU_Cout, ALU_zero);
RF: Register_File port map (RF_A1in, RF_A2in, RF_A3in, RF_D3in, rf_write, clock,reset, RF_D1out, RF_D2out);
IR: Register_16bit port map (mem_dataOut, ir_write, clock,reset, IRout);
SE: sign_extender port map (IRout(8 downto 0), IRout(5 downto 0), se_op_sel, se_in_sel, SEout);
LS: left_shifter port map (SEout, LSout);
T1: Register_16bit port map (RF_D1out, t1_write, clock,reset, T1out);
T2: Register_16bit port map (RF_D2out, t2_write, clock,reset, T2out);
Tpc: Register_16bit port map (ALU_Cout, t_pc_write, clock,reset, Tpcout);
mem_final:Memory port map(mem_addr_in,T1out,mem_write,clock,reset,mem_dataOut);
RF_A2in<=IRout(8 downto 6);
zero_flag<=ALU_zero;
ir_data<=IRout;


alu_sel_final:process(alu_a_sel,alu_b_sel,RF_D1out,Tpcout,T1out,T2out,LSout,SEout)
begin
	case alu_a_sel is
		when "00" =>
			ALU_Ain<=RF_D1out;
		when "01" =>
			ALU_Ain<=Tpcout;
		when "10" =>
			ALU_Ain<=T1out;
		when "11" =>
			ALU_Ain<=T2out;
		when others =>
			ALU_Ain<=T1out;
		end case;
	
	case alu_b_sel is
		when "00" =>
			ALU_Bin<="0000000000000010";
		when "01" =>
			ALU_Bin<=LSout;
		when "10" =>
			ALU_Bin<=SEout;
		when "11" =>
			ALU_Bin<=T2out;
		when others =>
			ALU_Bin<=LSout;
	end case;
end process;

rf_sel_proc:process(rf_a1_sel,rf_write,rf_a3_sel,rf_d3_sel,IRout,ALU_Cout,Tpcout,SEout,mem_dataOut,RF_D1out,RF_D2out)
begin
	if(rf_a1_sel='0') then
		RF_A1in<="111";
	else
		RF_A1in<=IRout(11 downto 9);
	end if;
	case rf_a3_sel is
		when "00" =>
			RF_A3in<="111";
		when "01" =>
			RF_A3in<=IRout(5 downto 3);
		when "10" =>
			RF_A3in<=IRout(8 downto 6);
		when "11" =>
			RF_A3in<=IRout(11 downto 9);
		when others =>
			RF_A3in<=IRout(11 downto 9);
	end case;

	case rf_d3_sel is
		when "000" =>
			RF_D3in<=ALU_Cout;
		when "001" =>
			RF_D3in<=Tpcout;
		when "010" =>
			RF_D3in<=SEout;
		when "011" =>
			RF_D3in<=mem_dataOut;
		when "100" =>
			RF_D3in<=RF_D1out;
		when "101" =>
			RF_D3in<=RF_D2out;
		when others =>
			RF_D3in<=ALU_Cout;
		end case;
end process;
mem_sel_proc:process(mem_addr_sel,ALU_Cout,RF_D1out)
begin
	if(mem_addr_sel='1')then
		mem_addr_in<=ALU_Cout;
	else
		mem_addr_in<=RF_D1out;
	end if;
end process;
	
end architecture bhv;
	
			
	
	



