
library IEEE;
use IEEE.std_logic_1164.all;

entity tb1 is
end tb1;

architecture TB1_ARCHITECTURE of tb1 is 
    signal 	sel_byte: std_logic_vector(1 downto 0);
    
    signal  input_word: std_logic_vector(31 downto 0); 
    
    signal  output_byte: std_logic_vector(31 downto 0);
begin  
    UTT : entity work.getBytefromWord
    port map (sel_byte => sel_byte, 
    			input_word =>  input_word, 
                output_byte => output_byte );

    sel_byte <= "00", "01" after 10 ns, "10" after 20 ns, "11" after 30 ns,"00" after 40 ns;  
    input_word <= x"52a3bcd6"; 
    

end TB1_ARCHITECTURE;
