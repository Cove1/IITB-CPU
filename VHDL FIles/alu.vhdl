library ieee;
use work.all;
use ieee.std_logic_1164.all;
entity Full_Adder is
   port (A, B,Cin: in std_logic; S, Cout: out std_logic);
end entity Full_Adder;

architecture Equations of Full_Adder is
begin
   S <= (A xor B xor Cin);
   Cout <= (A and B)or(B and Cin)or(A and Cin);
end Equations;


library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity Ripple_Adder is
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
B : in STD_LOGIC_VECTOR (3 downto 0);
Cin : in STD_LOGIC;
S : out STD_LOGIC_VECTOR (3 downto 0);
Cout : out STD_LOGIC);
end Ripple_Adder;

architecture Behavioral of Ripple_Adder is

-- Full Adder VHDL Code Component Decalaration

-- Intermediate Carry declaration
signal c1,c2,c3: STD_LOGIC;
component Full_Adder is
   port (A, B,Cin: in std_logic; S, Cout: out std_logic);
end component Full_Adder;

begin

-- Port Mapping Full Adder 4 times
FA1: Full_Adder port map( A(0), B(0), Cin, S(0), c1);
FA2: Full_Adder port map( A(1), B(1), c1, S(1), c2);
FA3: Full_Adder port map( A(2), B(2), c2, S(2), c3);
FA4: Full_Adder port map( A(3), B(3), c3, S(3), Cout);

end Behavioral;
library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity Full_Subtractor is
   port (A, B,Cin: in std_logic; S, Cout: out std_logic);
end entity Full_Subtractor;

architecture Equation of Full_Subtractor is
begin
   S <= (A xor B xor Cin);
   Cout <= (not(A) and B)or(B and Cin)or(not(A) and Cin);
end Equation;



library ieee;
use ieee.std_logic_1164.all;
use work.all;
entity multy is 
    port (
        x: in  std_logic_vector (3 downto 0);
        y: in  std_logic_vector (3 downto 0);
        p: out std_logic_vector (15 downto 0)
    );
end entity multy;

architecture rtl of multy is
--    component Ripple_Adder
--        port ( 
--            A:      in  std_logic_vector (3 downto 0);
--            B:      in  std_logic_vector (3 downto 0);
--            Cin:    in  std_logic;
--            S:      out std_logic_vector (3 downto 0);
--           Cout:    out std_logic
--        );
--    end component;
-- AND Product terms:
    signal G0, G1, G2:  std_logic_vector (3 downto 0);
-- B Inputs (B0 has three bits of AND product)
    signal B0, B1, B2:  std_logic_vector (3 downto 0);
	 component Ripple_Adder is
Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
B : in STD_LOGIC_VECTOR (3 downto 0);
Cin : in STD_LOGIC;
S : out STD_LOGIC_VECTOR (3 downto 0);
Cout : out STD_LOGIC);
end component Ripple_Adder;

begin

    -- y(1) thru y (3) AND products, assigned aggregates:
    G0 <= (x(3) and y(1), x(2) and y(1), x(1) and y(1), x(0) and y(1));
    G1 <= (x(3) and y(2), x(2) and y(2), x(1) and y(2), x(0) and y(2));
    G2 <= (x(3) and y(3), x(2) and y(3), x(1) and y(3), x(0) and y(3));
    -- y(0) AND products (and y0(3) '0'):
    B0 <=  ('0',          x(3) and y(0), x(2) and y(0), x(1) and y(0));

-- named association:
cell_1: 
    Ripple_Adder 
        port map (
            a => G0,
            b => B0,
            cin => '0',
            cout => B1(3), -- named association can be in any order
            S(3) => B1(2), -- individual elements of S, all are associated
            S(2) => B1(1), -- all formal members must be provide contiguously
            S(1) => B1(0),
            S(0) => p(1)
        );
cell_2: 
    Ripple_Adder 
        port map (
            a => G1,
            b => B1,
            cin => '0',
            cout => B2(3),
            S(3) => B2(2),
            S(2) => B2(1),
            S(1) => B2(0),
            S(0) => p(2)
        );
cell_3: 
    Ripple_Adder 
        port map (
            a => G2,
            b => B2,
            cin => '0',
            cout => p(7),
            S => p(6 downto 3)  -- matching elements for formal
        );
    p(0) <= x(0) and y(0); 
end architecture rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
 
 
entity alu is
	port (alu_s3,alu_op: in std_logic_vector(3 downto 0);
			alu_a,alu_b: in std_logic_vector(15 downto 0);
			alu_c: out std_logic_vector(15 downto 0);
			alu_zero: out std_logic);
end entity alu;

architecture bhv of alu is
signal alu_c_add,alu_c_sub,alu_c_mul,alu_c_or,alu_c_and,alu_c_imply: std_logic_vector(15 downto 0):="0000000000000000";
signal carry_s,carry_a: std_logic_vector(16 downto 0):="00000000000000000";
component Full_Adder is
   port (A, B,Cin: in std_logic; S, Cout: out std_logic);
end component Full_Adder;
component multy is 
    port (
        x: in  std_logic_vector (3 downto 0);
        y: in  std_logic_vector (3 downto 0);
        p: out std_logic_vector (15 downto 0)
    );
end component multy;
component Full_Subtractor is
   port (A, B,Cin: in std_logic; S, Cout: out std_logic);
end component Full_Subtractor;

begin 
sub_total:for i in 0 to 15 generate
	s_1:Full_Subtractor port map(alu_a(i),alu_b(i),carry_s(i),alu_c_sub(i),carry_s(i+1));
end generate;
add_total:for i in 0 to 15 generate
	s_1:Full_Adder port map(alu_a(i),alu_b(i),carry_a(i),alu_c_add(i),carry_a(i+1));
end generate;
alu_c_and<= alu_a and alu_b;
alu_c_or<= alu_a or alu_b;
alu_c_imply<= (not(alu_a)) or alu_b;
multi:multy port map(alu_a(3 downto 0),alu_b(3 downto 0),alu_c_mul);

outp:process(alu_s3,alu_op,alu_c_sub,alu_c_add,alu_c_mul,alu_c_and,alu_c_or,alu_c_imply)
begin
if(alu_s3="0011") then
	case alu_op is
		when "0010" =>
			alu_zero<='0';
			alu_c<= alu_c_sub;
		when "1100" =>
			alu_c<= alu_c_sub;
			if(alu_c_sub="0000000000000000") then
				alu_zero<='1';
			else
				alu_zero<='0';
			end if;
		when "0011"=>
			alu_zero<='0';
			alu_c<= alu_c_mul;
		when "0100"=>
			alu_zero<='0';
			alu_c<= alu_c_and;
		when "0101"=>
		 	alu_zero<='0';
			alu_c<= alu_c_or;
		when "0110"=>
			alu_zero<='0';
			alu_c<= alu_c_imply;
		when others=>
			alu_zero<='0';
			alu_c<= alu_c_add;
	end case;
else
alu_c<=alu_c_add;
alu_zero<='0';
end if;
end process;
end architecture bhv;