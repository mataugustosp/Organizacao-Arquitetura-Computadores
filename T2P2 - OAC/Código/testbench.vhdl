library ieee;
use ieee.std_logic_1164.all;

entity tb is 
end tb;

architecture tb_arch of tb is
 
signal clock: std_logic := '0';
signal reset: std_logic := '0';

begin
	
	UUT : entity work.rv
	port map ( 
			clock => clock,
			reset => reset
	);
	
	-- 100 MHz
	clock <= not clock after 5 ns;
	
	reset <= '1', '0' after 2 ns;
	
end tb_arch;
