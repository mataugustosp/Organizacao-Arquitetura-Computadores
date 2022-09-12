library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use std.env.stop;

entity rv is
	port	( 
				clock: in std_logic;
				reset: in std_logic
			);
end rv;

architecture rv_arch of rv is
	
	signal pc			: std_logic_vector(31 downto 0) := (others => '0');
	
	--pc mux
	signal pc_mux_out	: std_logic_vector(31 downto 0);
	signal branch		: std_logic;
    signal jal			: std_logic;
    signal jalr			: std_logic;



    --bregwrite mux
    signal bregwrite	: std_logic_vector(1 downto 0);
    signal bregwrite_output : std_logic;
	
	--instruction memory
	signal inst			: std_logic_vector(31 downto 0);
	
	--instruction decode
	signal opcode		: std_logic_vector(6 downto 0); 
	signal rd			: std_logic_vector(4 downto 0); 
	signal funct3		: std_logic_vector(2 downto 0); 
	signal rs1			: std_logic_vector(4 downto 0); 
	signal rs2			: std_logic_vector(4 downto 0); 
	signal funct7		: std_logic_vector(6 downto 0); 
	signal imm32		: std_logic_vector(31 downto 0);
	
	--regfile
	signal reg_write_data	: std_logic_vector(31 downto 0);
	signal reg_data_1		: std_logic_vector(31 downto 0);
	signal reg_data_2		: std_logic_vector(31 downto 0);
	
	--alu
	signal aluB		: std_logic_vector(31 downto 0);
	signal operation: std_logic_vector(3 downto 0);
	signal result	: std_logic_vector(31 downto 0);
	
	--alu mux
	signal origALU: std_logic;
		
	--data memory
	signal dmem_address		: std_logic_vector(31 downto 0);
	signal dmemwrite		: std_logic;
	signal dmemread			: std_logic;
	signal dmem_read_data	: std_logic_vector(31 downto 0);
	
	--breg mux
	signal data2reg: std_logic_vector(2 downto 0);
	
	--syscall
	signal syscall_reg : std_logic_vector(31 downto 0) := (others => '0');
	signal syscall_parameter_reg : std_logic_vector(31 downto 0) := (others => '0');
		
begin

	pc_reg: process(clock, reset) 
	begin
		if(reset = '1') then
			pc <= (others => '0');
		elsif rising_edge(clock) then 
			pc <= pc_mux_out;
		end if;
	end process;
	
	--mux para decidir o proximo valor armazenado em PC
    pc_mux_out <= 
        std_logic_vector(signed(pc) + signed(imm32)) when (jal or (result(0) and branch)) else
        result when jalr = '1' else 
        std_logic_vector(unsigned(pc) + 4);
    
    -- mux para definir se escrevemos ou nao no registrador 
    bregwrite_output <=
            '0' when bregwrite = "00" else 

            '1' when bregwrite = "01" else 

            '1' when result(31) = '0' and bregwrite = "10" else 

            '0' when result(31) = '1' and bregwrite = "10" else 

            '1' when reg_data_1 /= reg_data_2 and bregwrite = "11" else

            '0' when reg_data_1 /= reg_data_2 and bregwrite = "11" else
            
            '0';
    


	top_imem : entity work.imem
	port map ( 
			address => pc(8 downto 2),
			inst => inst
	);
	
	top_instdecod : entity work.instdecod
	port map ( 
			inst 	=> inst,
			opcode	=> opcode,
			rd		=> rd,
			funct3	=> funct3,
			rs1		=> rs1,
			rs2		=> rs2,
			funct7	=> funct7,
			imm32	=> imm32
	);
	
	top_breg : entity work.breg
	port map ( 
			clock 			=> clock,
			bregwrite		=> bregwrite_output,	
			reg_index_read1	=> rs1,
			reg_index_read2	=> rs2,
			reg_index_write	=> rd,
			reg_write_data	=> reg_write_data,
			reg_data_1		=> reg_data_1,
			reg_data_2		=> reg_data_2	
	);
	
	--mux para decidir o que tera na entrada B da ULA
	aluB <= reg_data_2 when origALU='0' else imm32;
	
	top_alu : entity work.alu
	port map ( 
			A 			=> reg_data_1, 		
			B 			=> aluB,		
			operation	=> operation,
			result		=> result	
	);
	
	--subtrai-se 0x00002000 (8192 em decimal) de  result e atribui ao endereco da memoria de dados
	dmem_address <= std_logic_vector(unsigned(result) - 8192);
	
	top_dmem : entity work.dmem
	port map ( 
			clock			=> clock,			
			address 		=> dmem_address(8 downto 2),			
			dmemwrite		=> dmemwrite,
			dmemread		=> dmemread,	
			dmem_write_data => reg_data_2,	
			dmem_read_data	=> dmem_read_data	
	); 
	
    --mux para decidir o que sera escrito em um registrador
    -- Adicionaremos aqui uma logica para o  getbfw 
    reg_write_data <=              
                    (31 downto 8 => '0') & reg_data_1(7 downto 0) when (data2reg="101" and reg_data_2 = x"00000000")
                    else (31 downto 8 => '0') & reg_data_1(15 downto 8) when (data2reg="101" and reg_data_2 = x"00000001")
                    else (31 downto 8 => '0') & reg_data_1(23 downto 16) when (data2reg="101" and reg_data_2 = x"00000002")
                    else (31 downto 8 => '0') & reg_data_1(31 downto 17) when (data2reg="101" and reg_data_2 = x"00000003")
                    else std_logic_vector(signed(pc) + signed(imm32)) when data2reg="100" 
					else imm32 when data2reg="011" 
					else std_logic_vector(unsigned(pc) + 4) when data2reg="010" 
					else dmem_read_data when data2reg="001" 
					else result when data2reg="000" 
					else (others=>'0');
	
	top_maincontrol : entity work.maincontrol
	port map ( 
			opcode		=> opcode,
			funct3		=> funct3,			
			funct7		=> funct7,			
			origALU		=> origALU,		
			dmemread	=> dmemread,	
			dmemwrite	=> dmemwrite,		
			bregwrite	=> bregwrite,	
	        branch		=> branch,		
	        data2reg	=> data2reg,		
            jal			=> jal,
            jalr		=> jalr,
	        operation	=> operation		
	); 
	
	--process para gerar o arquivo de debug de saida e simular algumas chamadas de sistema do RARS
	ecall_file: process(reset, clock)
		constant output_file	: string := "output_file.txt";
		file file_ptr			: text;
		variable fstatus       	: file_open_status;
		variable file_line		: line;
	begin
		if(reset = '1') then
			file_open(fstatus, file_ptr, output_file, write_mode);
			file_close(file_ptr);
		else
			if rising_edge(clock) then
				file_open(fstatus, file_ptr, output_file, append_mode);
				if(bregwrite_output = '1') then
					write(file_line, "REG : " & to_string(to_integer(unsigned(rd))) & " : " & to_hstring(reg_write_data));
					writeline(file_ptr, file_line);
					--ecall register a0
					if(to_integer(unsigned(rd)) = 10) then
						syscall_parameter_reg <= reg_write_data;
					end if;	
					--ecall register a7
					if(to_integer(unsigned(rd)) = 17) then
						syscall_reg <= reg_write_data;
					end if;	
				end if;
				if(dmemwrite = '1' and dmemread = '0') then
					write(file_line, "MEM : " & to_hstring(result) & " : " & to_hstring(reg_data_2));
					writeline(file_ptr, file_line);
				end if;
				--ecall instruction
				if(opcode = "1110011") then
					if (to_integer(unsigned(syscall_reg)) = 1) then
						write(file_line, "syscall print int: " & to_string(to_integer(unsigned(syscall_parameter_reg))));
						writeline(file_ptr, file_line);
					end if;
					if (to_integer(unsigned(syscall_reg)) = 10) then
						write(file_line, string'("syscall exit"));
						writeline(file_ptr, file_line);
						stop;
					end if;
				end if;
				file_close(file_ptr);
			end if;
		end if;
	end process;
	
end architecture rv_arch;





