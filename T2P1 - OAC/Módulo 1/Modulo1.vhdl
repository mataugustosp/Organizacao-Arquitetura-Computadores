library IEEE;
use IEEE.std_logic_1164.all;

entity getBytefromWord is
port (
       sel_byte: in std_logic_vector(1 downto 0); 
       input_word: in std_logic_vector(31 downto 0); 
       output_byte: out std_logic_vector(31 downto 0)
);
end entity getBytefromWord;

architecture pt1 of getBytefromWord is

begin
      selection : process (all)
        begin
          case sel_byte is
            when "00" =>
                output_byte <= (31 downto 8 => '0') & input_word(7 downto 0);
            when "01" =>
                output_byte <= (31 downto 8 => '0') & input_word(15 downto 8); 
              when "10" =>
                  output_byte <= (31 downto 8 => '0') & input_word(23 downto 16); 
              when others =>
                  output_byte <= (31 downto 8 => '0') & input_word(31 downto 24); 
      end case;
        end process;
end pt1;