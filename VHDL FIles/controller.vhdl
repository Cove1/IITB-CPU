library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	port (ir:in std_logic_vector(15 downto 0);
			clock,z:in std_logic;
			ir_write,rf_a1_sel,mem_addr_sel,rf_write,t_pc_write,t1_write,t2_write,mem_write,se_in_sel,se_op_sel:out std_logic;
			alu_a_sel,alu_b_sel,rf_a3_sel:out std_logic_vector(1 downto 0);
			rf_d3_sel:out std_logic_vector(2 downto 0);
			out_state,out_op:out std_logic_vector(3 downto 0));
end entity controller;

architecture bhv of controller is
	signal current_state,next_state : std_logic_vector(3 downto 0):="0001";
	signal op_state:std_logic_vector(3 downto 0);
begin
op_state<= ir(15 downto 12);
out_state<=current_state;
out_op<=op_state;

state_machine:process(op_state,current_state,next_state)
begin
	case op_state is 
		when "0000"|"0010"|"0011"|"0001"|"0100"|"0101"|"0110"|"1100" =>
			if(current_state="0001") then
				next_state<="0010";
			elsif (current_state="0010") then
				next_state<="0011";
			elsif (current_state="0011") then
				next_state<="0001";
			else
				next_state<="0001";
			end if;
		when "1000"|"1001" =>
			if(current_state="0001") then
				next_state<="0100";
			elsif (current_state="0100") then
				next_state<="0001";
			else
				next_state<="0001";
			
			end if;
		when "1010" =>
			if(current_state="0001") then
				next_state<="0010";
			elsif (current_state="0010") then
				next_state<="0101";
			elsif (current_state="0101") then
				next_state<="0001";
			else
				next_state<="0001";
			end if;
		when "1011" =>
			if(current_state="0001") then
				next_state<="0010";
			elsif (current_state="0010") then
				next_state<="0110";
			elsif (current_state="0110") then
				next_state<="0001";
			else
				next_state<="0001";
			end if;
		when "1101" =>
			if(current_state="0001") then
				next_state<="0111";
			elsif (current_state="0111") then
				next_state<="1000";
			elsif (current_state="1000") then
				next_state<="0001";
			else
				next_state<="0001";
			end if;
		when "1111" =>
			if(current_state="0001") then
				next_state<="0111";
			elsif (current_state="0111") then
				next_state<="1001";
			elsif (current_state="1001") then
				next_state<="0001";
			else
				next_state<="0001";
			end if;
		when others =>
			next_state<="0001";
	end case;
end process;
state_transition:process(current_state,next_state,clock)
begin
	if(clock='0' and clock'event) then
		current_state<=next_state;
	end if;
end process;




main_control:process(current_state,op_state,z)
begin
	case current_state is 
		when "0001" => 
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="00";-- alu_a -> rf_d1
			alu_b_sel<="00";-- alu_b -> 2
			rf_d3_sel<="000";-- rf_d3 -> alu_c
			rf_a3_sel<="00"; -- rf_a3 -> 111
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='1';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
			ir_write<='1';
		when "0010" =>
			rf_a1_sel<='1';--rf_a1 -> ir(9-11)
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="01";-- alu_a -> tpc 
			alu_b_sel<="01";-- alu_b -> ls_out
			rf_d3_sel<="000";-- rf_d3 -> 
			rf_a3_sel<="00"; -- rf_a3 -> 
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='1';
			rf_write<='0';
			t1_write<='1';
			t2_write<='1';
			mem_write<='0';
			ir_write<='0';
		when "0011" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="10";-- alu_a -> t1
			if(op_state="0001") then
				alu_b_sel<="10"; --seout
			else
				alu_b_sel<="11"; -- t2
			end if;
			if(z='1') then
				rf_d3_sel<="001";-- tpc
			else
				rf_d3_sel<="000"; -- alu_c
			end if;
			if(z='0' and op_state/="0001") then
				rf_a3_sel<="01"; -- ir 3-5
			elsif(z='0' and op_state="0001") then
				rf_a3_sel<="10";
			elsif(z='1' and op_state/="0001") then
				rf_a3_sel<="00";
			else
				rf_a3_sel<="10";
			end if;
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='1';
			if(op_state/="1100" or (z='1' and op_state="1100")) then
				rf_write<='1';
			else
				rf_write<='0';
			end if;
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
			
		when "0100" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="00";-- alu_a -> 
			alu_b_sel<="00";-- alu_b -> 
			rf_d3_sel<="010";-- rf_d3 -> se_out
			rf_a3_sel<="11"; -- rf_a3 -> ir(9-11)
			se_in_sel<='1';
			if(op_state="1001") then
				se_op_sel<='0';
			else
				se_op_sel<='1';
			end if;
			t_pc_write<='0';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		when "0101" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='1';--mem_addr_in -> alu_c(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="11";-- alu_a -> t2 
			alu_b_sel<="10";-- alu_b -> se_out
			rf_d3_sel<="011";-- rf_d3 -> mem_data_out
			rf_a3_sel<="11"; -- rf_a3 -> ir(9-11)
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		when "0110" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='1';--mem_addr_in -> alu_c(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="11";-- alu_a -> t2
			alu_b_sel<="10";-- alu_b -> se_out
			rf_d3_sel<="000";-- rf_d3 -> 
			rf_a3_sel<="00"; -- rf_a3 -> 
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='0';
			t1_write<='0';
			t2_write<='0';
			mem_write<='1';
		when"0111" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="00";-- alu_a -> 
			alu_b_sel<="00";-- alu_b -> 
			rf_d3_sel<="100";-- rf_d3 -> rf_d1
			rf_a3_sel<="11"; -- rf_a3 -> ir(9-11)
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		when "1000" =>
			ir_write<='0';
			rf_a1_sel<='1';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="01";-- alu_a -> tpc
			alu_b_sel<="01";-- alu_b -> ls_out
			rf_d3_sel<="000";-- rf_d3 -> alu_c
			rf_a3_sel<="00"; -- rf_a3 -> 111
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		when "1001" =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="00";-- alu_a -> 
			alu_b_sel<="00";-- alu_b -> 
			rf_d3_sel<="101";-- rf_d3 -> rf_d2
			rf_a3_sel<="00"; -- rf_a3 -> 111
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='1';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		when others =>
			ir_write<='0';
			rf_a1_sel<='0';--rf_a1 -> 111	
			mem_addr_sel<='0';--mem_addr_in -> rf_d1(find out about msb or lsb in mem, which one comes first??
			alu_a_sel<="00";-- alu_a -> 
			alu_b_sel<="00";-- alu_b -> 
			rf_d3_sel<="000";-- rf_d3 -> 
			rf_a3_sel<="00"; -- rf_a3 -> 
			se_in_sel<='0';
			se_op_sel<='0';
			t_pc_write<='0';
			rf_write<='0';
			t1_write<='0';
			t2_write<='0';
			mem_write<='0';
		end case;
	end process;
end architecture bhv;
			
			
			
			
			

			

		