-- Decodificação de instrução 


library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity instdecod is
	port	( 
				inst	: in std_logic_vector(31 downto 0);
				opcode	: out std_logic_vector(6 downto 0); 
				rd		: out std_logic_vector(4 downto 0); 
				funct3	: out std_logic_vector(2 downto 0); 
				rs1		: out std_logic_vector(4 downto 0); 
				rs2		: out std_logic_vector(4 downto 0); 
				funct7	: out std_logic_vector(6 downto 0); 
				imm32	: out std_logic_vector(31 downto 0)
			);
end instdecod;

architecture instdecod_arch of instdecod is
begin

	opcode <= inst(6 downto 0);
	rd <= inst(11 downto 7);	
	funct3 <= inst(14 downto 12);
	rs1	<= inst(19 downto 15);	
	rs2	<= inst(24 downto 20);	
	funct7 <= inst(31 downto 25);	
		
	--imm32
	process (all) begin
	
        case '0' & inst(6 downto 0) is
			when x"33" => imm32 <= (others => '0');
			when x"03" | x"13" | x"67" => imm32 <= (31 downto 12 => inst(31)) & inst(31 downto 20);
			when x"23" => imm32 <= (31 downto 12 => inst(31)) & inst(31 downto 25) & inst(11 downto 7);
            when x"63" => imm32 <= (31 downto 13 => inst(31)) & inst(31) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0';
            
			when x"17" | x"37" => imm32 <= inst(31 downto 12) & (11 downto 0 => '0');
			when x"6F" => imm32 <= (31 downto 20 => inst(31)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0';
			when others => imm32 <= (others => '0');
		end case;
	
	end process;
	
end architecture instdecod_arch;

