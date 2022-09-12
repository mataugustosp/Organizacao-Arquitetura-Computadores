
-- ULA é a propria ULA 

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity alu is
	port	( 
				A, B: in std_logic_vector(31 downto 0); 
				operation: in std_logic_vector(3 downto 0);
				result: out std_logic_vector(31 downto 0)
			);
end alu;

architecture alu_arch of alu is
begin

	process (all) 
	begin
	
		case operation is
			when "0000" => result <= std_logic_vector(signed(A)+signed(B));
			when "0001" => result <= std_logic_vector(signed(A)-signed(B));
			when "0010" => result <= std_logic_vector(shift_left(signed(A), to_integer(unsigned(B))));
			when "0011" =>
				if(signed(a)<signed(b)) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when "0100" =>
				if(unsigned(a)<unsigned(b)) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when "0101" => result <= a xor b;
			when "0110" => result <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			when "0111" => result <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
			when "1000" => result <= a or b;
			when "1001" => result <= a and b;
			when "1010" =>
				if(a=b) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when "1011" =>
				if(a/=b) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when "1100" =>
				if(signed(a)>=signed(b)) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when "1101" =>
				if(unsigned(a)>=unsigned(b)) then 
					result <= x"00000001";
				else result <= (others => '0');
				end if;
			when others => result <= (others => '0'); 
		end case;
	
	end process;

end architecture alu_arch;

