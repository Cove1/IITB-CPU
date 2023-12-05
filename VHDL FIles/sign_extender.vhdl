library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is 
	port (in_9:in std_logic_vector(8 downto 0);
				in_6:in std_logic_vector(5 downto 0);
				op_sel,in_sel:in std_logic;
				outp:out std_logic_vector(15 downto 0));
end entity sign_extender;

architecture bhv of sign_extender is

begin
sign_extend:process(op_sel,in_sel,in_9,in_6)
begin
	if(in_sel='1') then
		if(op_sel='0') then
			outp<= "0000000" & in_9;
		else
			outp<= in_9 & "0000000";
		end if;
	else
		outp<= "0000000000" & in_6;
	end if;
end process;
end architecture bhv;
		
