--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity Memory is 
--    port (Mem_Add,Mem_Data_in :in std_logic_vector(15 downto 0);
--          Mem_write,Clock :in std_logic;
--		    Mem_Data_out :out std_logic_vector (15 downto 0));
--end entity Memory;
--
--architecture behv of Memory is
--   type Memory_data_type is Array (0 to 499) of std_logic_vector(7 downto 0);
--   signal Mem_data : Memory_data_type := 
--        ("11000000",
--		   "01001111",
--			"00000010",
--			"10011000",
--			"00000101",
--			"10010011",
--			others=>"00000000");
--begin 
--
--      Memory_read : process (Mem_Add,Mem_data)
--		begin 
--		   
--			   Mem_Data_out <= Mem_data(To_integer(unsigned(Mem_Add))) & Mem_data(To_integer(unsigned(Mem_Add )) + 1);
--		
--		end process; 
--		
--		Memory_write : process (Mem_Data_in,Clock,Mem_Add)
--		begin 
--		   if (Clock'event and Clock = '0') then 
--			   if (Mem_write = '1') then 
--				   Mem_data(To_integer(unsigned(Mem_Add))) <= Mem_Data_in(15 downto 8) ;
--					Mem_data(To_integer(unsigned(Mem_Add)) + 1) <= Mem_Data_in(7 downto 0);
--				end if ;
--			end if ;
--		end process;
--end behv;
--		
	
--	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Memory is 
    port (Mem_Add,Mem_Data_in :in std_logic_vector(15 downto 0);
          Mem_write,Clock,reset :in std_logic;
		    Mem_Data_out :out std_logic_vector (15 downto 0));
end entity Memory;

architecture behv of Memory is
   type Memory_data_type is Array (0 to 499) of std_logic_vector(7 downto 0);
   signal Mem_data,init_data : Memory_data_type := (others=>"00000000");
	impure function init_mem return Memory_data_type is
		file text_file : text open read_mode is "C:\Users\arin weling\Desktop\Apple_M69\Memory.txt";
		variable text_line : line;
		variable mem_content : Memory_data_type;
		begin
			for i in 0 to 499 loop
				readline(text_file, text_line);
				read(text_line, mem_content(i));
			end loop;	
		return mem_content;
	end function;
	 -- File variables
--    file inputFile: text;
--    variable fileLine: line;

begin 
		init_data<=init_mem;
      Memory_file_read_write : process (reset,Mem_Data_in,Clock,Mem_Add)
		begin 
		if (reset = '1') then 
			Mem_data<=init_data;
		else
		if (Clock'event and Clock = '1' and reset='0') then 
			   if (Mem_write = '1') then 
				   Mem_data(To_integer(unsigned(Mem_Add))) <= Mem_Data_in(15 downto 8) ;
					Mem_data(To_integer(unsigned(Mem_Add)) + 1) <= Mem_Data_in(7 downto 0);
				end if ;
			end if;
		end if ;
		end process;
		
		
	 Memory_read : process (Mem_Add,Mem_data)
		begin 
		   
			   Mem_Data_out <= Mem_data(To_integer(unsigned(Mem_Add))) & Mem_data(To_integer(unsigned(Mem_Add )) + 1);
		
		end process; 
--		
--		Memory_write : process (Mem_Data_in,Clock,Mem_Add,reset)
--		begin 
--		   if (Clock'event and Clock = '1' and reset='0') then 
--			   if (Mem_write = '1') then 
--				   Mem_data(To_integer(unsigned(Mem_Add))) <= Mem_Data_in(15 downto 8) ;
--					Mem_data(To_integer(unsigned(Mem_Add)) + 1) <= Mem_Data_in(7 downto 0);
--				end if ;
--			end if ;
--		end process;

end behv;	