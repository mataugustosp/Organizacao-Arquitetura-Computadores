library ieee;
use ieee.std_logic_1164.all; 


entity tb2 is
end tb2;

architecture TB2_ARCHITECTURE of tb2 is 

signal clock: std_logic;
signal reset: std_logic;
signal inst: std_logic_vector(31 downto 0); 
signal add_counter: std_logic_vector(31 downto 0); 
signal sub_counter: std_logic_vector(31 downto 0); 
signal slt_counter: std_logic_vector(31 downto 0);
signal and_counter: std_logic_vector(31 downto 0); 
signal or_counter: std_logic_vector(31 downto 0); 
signal lw_counter: std_logic_vector(31 downto 0);
signal sw_counter: std_logic_vector(31 downto 0); 
signal beq_counter: std_logic_vector(31 downto 0); 
signal jal_counter: std_logic_vector(31 downto 0);

begin  
    UTT : entity work.instructionCounter 
    port map (clock => clock, 
            reset =>  reset, 
            inst => inst,
            add_counter => add_counter,
            sub_counter => sub_counter,
            slt_counter => slt_counter,
            and_counter => and_counter,
            or_counter => or_counter, 
            lw_counter => lw_counter,
            sw_counter => sw_counter,
            beq_counter => beq_counter,
            jal_counter => jal_counter);
            
	reset <= '1', '0' after 10 ns, '1' after 180 ns, '0' after 190 ns;
    clock <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns,'0' after 40 ns,'1' after 50 ns,'0' after 60 ns,'1' after 70 ns,'0' after 80 ns,'1' after 90 ns,'0' after 100 ns,'1' after 110 ns,'0' after 120 ns,'1' after 130 ns,'0' after 140 ns, '1' after 150 ns,'0' after 160 ns, '1' after 170 ns,'0' after 180 ns;
    
    
    inst <= "00000001111111111000111110110011", 
    "01000001111111111000111110110011" after 20 ns,
    "00000001111111111010111110110011" after 40 ns,
    "00000001111111111110111110110011" after 60 ns,
    "00000001111111111111111110110011" after 80 ns,
    "00000001111111111010111110000011" after 100 ns,
    "00000001111111111010111110100011" after 120 ns,
    "00000001111111111000111111100011" after 140 ns,
    "00000001111111111010111111101111" after 160 ns
     
    ; 
    

end TB2_ARCHITECTURE;

