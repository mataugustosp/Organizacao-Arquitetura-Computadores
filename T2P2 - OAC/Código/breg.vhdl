
-- Banco de registradores 

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity breg is
	generic(	
				WSIZE		:	natural	:=	32;
				ISIZE		:	natural	:=	5;
				BREGSIZE	:	natural	:=	32
			);
	port(
			clock 			:		in	std_logic;
			bregwrite       :		in	std_logic;
			reg_index_read1	:		in	std_logic_vector(ISIZE-1 downto	0);
			reg_index_read2	:		in	std_logic_vector(ISIZE-1 downto	0);
			reg_index_write	:		in	std_logic_vector(ISIZE-1 downto	0);
			reg_write_data	:		in	std_logic_vector(WSIZE-1 downto	0);
			reg_data_1		:		out	std_logic_vector(WSIZE-1 downto	0);
			reg_data_2		:		out	std_logic_vector(WSIZE-1 downto	0)
	);
end	entity;

architecture breg_arch of breg	is

	type	reg_array_t is array(0 to ((2**ISIZE)-1)) of std_logic_vector(WSIZE-1 downto 0);
	signal	breg_array: reg_array_t := (others => (others	=> '0'));
   
begin

	reg_data_1 <= breg_array(to_integer(unsigned(reg_index_read1))) when (to_integer(unsigned(reg_index_read1))>0) else (others => '0');
	reg_data_2 <= breg_array(to_integer(unsigned(reg_index_read2))) when (to_integer(unsigned(reg_index_read2))>0) else (others => '0');

	process	(clock)
	begin
		if	(rising_edge(clock))	then
			if	(bregwrite = '1')	then
				if (reg_index_write /= "00000" ) then
					breg_array(to_integer(unsigned(reg_index_write))) <= reg_write_data;
				end if;
			end	if;
		end	if;
	end	process;
		
end architecture breg_arch;
