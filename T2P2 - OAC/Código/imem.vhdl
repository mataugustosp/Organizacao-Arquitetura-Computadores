
--Memória de Instrução

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity imem is
	port(
		address	: in  std_logic_vector(6 downto 0);
        inst	: out std_logic_vector(31 downto 0)
	);
end;     

architecture imem_arch of imem is
	
		constant	MEM_SIZE: integer := 128; 
        type mem is array(0 to MEM_SIZE-1) of STD_LOGIC_VECTOR(31 downto 0);
                
        impure function load_mem (mem_file : in string) return mem is
	        
	        file file_ptr	: text open read_mode is mem_file;
  			variable inline	: line;
  			variable i		: integer := 0;
  			
  			variable mem_aux : mem := (others => (others => '0'));
	        
  		begin
  			
  			while not endfile(file_ptr) loop 
  				
  				if (i < MEM_SIZE) then
	  		    	readline(file_ptr, inline);
					hread(inline, mem_aux(i));
					i := i + 1;
				else
					exit;
				end if;
  				
  			end loop;
			
			file_close(file_ptr);
			
        	return mem_aux;
        	
    	end load_mem;
	
	signal i_mem: mem := load_mem("imem.txt");
	
begin

	inst <= i_mem(to_integer(unsigned(address)));
	
end;
