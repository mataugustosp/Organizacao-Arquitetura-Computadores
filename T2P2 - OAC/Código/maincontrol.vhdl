-- Controle 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maincontrol is
	port(
			opcode		: in  std_logic_vector(6 downto 0);
			funct3		: in std_logic_vector(2 downto 0);
			funct7		: in std_logic_vector(6 downto 0);
			origALU		: out std_logic;
			dmemread	: out std_logic;
			dmemwrite	: out std_logic;
			bregwrite	: out std_logic_vector(1 downto 0);
			branch		: out std_logic;
			data2reg	: out std_logic_vector(2 downto 0);
            jal			: out std_logic;
            jalr		: out std_logic;
            operation	: out std_logic_vector(3 downto 0)
            

	);
end maincontrol;

architecture maincontrol_arch of maincontrol is
	
begin

	process(all)
	begin
		case opcode is
			-- tipo-R
			when "0110011" =>
				origALU	<= '0';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "000";
                branch <= '0';
                jal <= '0';	
                jalr <= '0';	
				
				case funct3 is
					
					--add ou sub
					when "000" =>
                        if funct7 = "0000000" then --add
                            bregwrite <= "01";	
							operation <= "0000";
                        elsif funct7 = "0100000" then --sub
                            bregwrite <= "01";	
                            operation <= "0001";
                        -- ADDRPOS
                        elsif funct7 = "0000001" then
                            -- seleciona a saída pro addrpos
                            bregwrite <= "10";	
                            operation <= "0000";                            
						else 
							operation <= (others=>'0');
						end if;
					
					--sll
					when "001" =>
						operation <= "0010";
					
					--slt
					when "010" =>
						operation <= "0011";
					
					--sltu
					when "011" =>
						operation <= "0100";
					
					--xor
					when "100" =>
						operation <= "0101";
					
					--srl ou sra
					when "101" =>
						if funct7 = "0000000" then --srl
							operation <= "0110";
						elsif funct7 = "0100000" then --sra
							operation <= "0111";
						else 
							operation <= (others=>'0');
						end if;
					
					--or
					when "110" =>
						operation <= "1000";
					
					--and
					when "111" =>
						operation <= "1001";
					
					when others =>
						operation <= "----";
						
				end case;	
			
			-- lw
			when "0000011"=>
				origALU	<= '1';
			    dmemread <= '1';	
			    dmemwrite <= '0';
			    data2reg <= "001";
                bregwrite <= "01";	
                branch <= '0';
                jal <= '0';	
                jalr <= '0';
                operation <= "0000";	
                
                
             -- sw
			when "0100011"=>
				origALU	<= '1';
			    dmemread <= '0';	
			    dmemwrite <= '1';
			    data2reg <= "---";
                bregwrite <= "00";	
                branch <= '0';
                jal <= '0';
                jalr <= '0';
				operation <= "0000";
				
             -- branch
			when "1100011"=>
				origALU	<= '0';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "---";
                bregwrite <= "00";	
                branch <= '1';
                jal <= '0';
                jalr <= '0';
                
                case funct3 is
					
					--beq
					when "000" =>
						operation <= "1010";
						
					--bne
					when "001" =>
						operation <= "1011";
					
					--blt
					when "100" =>
						operation <= "0011";
					
					--bge
					when "101" =>
						operation <= "1100";
											
					--bltu
					when "110" =>
						operation <= "0100";
					
					--bgeu
					when "111" =>
						operation <= "1101";
					
					when others =>
						operation <= "----";
						
				end case;
              
             -- jal
			when "1101111"=>
				origALU	<= '-';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "010";
                bregwrite <= "01";	
                branch <= '0';
                jal <= '1';
                jalr <= '0';
                operation <= "----";
            
            -- tipo-I exceto loads e jalr
			when "0010011"=>
				origALU	<= '1';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "000";
                bregwrite <= "01";	
                branch <= '0';
                jal <= '0';	
                jalr <= '0';
				
				case funct3 is
					
					--addi
					when "000" =>
						operation <= "0000";
						
					--slli
					when "001" =>
						operation <= "0010";
					
					--slti
					when "010" =>
						operation <= "0011";
					
					--sltiu
					when "011" =>
						operation <= "0100";
					
					--xori
					when "100" =>
						operation <= "0101";
					
					--srli ou srai
					when "101" =>
						if funct7 = "0000000" then --srli
							operation <= "0110";
						elsif funct7 = "0100000" then --srai
							operation <= "0111";
						else 
							operation <= (others=>'0');
						end if;
					
					--ori
					when "110" =>
						operation <= "1000";
					
					--andi
					when "111" =>
						operation <= "1001";
					
					when others =>
						operation <= "----";
						
                end case;	
                
			
			--lui
			when "0110111"=>
				origALU	<= '-';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "011";
                bregwrite <= "01";	
                branch <= '0';
                jal <= '0';
                jalr <= '0';
                operation <= "----";
                
            --auipc
			when "0010111"=>
				origALU	<= '-';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "100";
                bregwrite <= "01";	
                branch <= '0';
                jal <= '0';
                jalr <= '0';
                operation <= "----";


            -- JALR
            when "1100111"=>
            -- Pega o imediato
            origALU	<= '1';
            dmemread <= '0';	
            dmemwrite <= '0';
            -- Pega o PC + 4
            data2reg <= "010";
            -- Escreve nos registradores 
            bregwrite <= "01";	
            branch <= '-';
            jal <= '-';	
            -- Faz o pc pegar rs1 + imm
            jalr <= '1';
            -- Soma para PC = RS1 + Imm
            operation <= "0000";

            -- ADDINE
            when "0001111"=>
            -- imediato pois rd = rs1 + imm
            origALU	<= '1';
            dmemread <= '0';	
            dmemwrite <= '0';
            -- Pega o resultado da ula 
            data2reg <= "000";
            -- O mux do breg pega o resultado do rs1 /= imm
            bregwrite <= "11";	
            branch <= '-';
            jal <= '-';	
            jalr <= '-';
            -- Soma para rs1 + imm
            operation <= "0000";

            --  getbfw
             when "1111111"=>

             -- criamos uma nova entrada no  mux do resultado 
             --Pega o rst2
             origALU <= '0';
             dmemread <= '0';	
             dmemwrite <= '0';
             -- Colocamos 5 que é o numero para o mux 
             data2reg <= "101";
             bregwrite <= "01";	
             branch <= '0';
             jal <= '0';	
             jalr <= '-';
             operation <= "----";
            
            -- others
			when others =>
				origALU	<= '-';
			    dmemread <= '0';	
			    dmemwrite <= '0';
			    data2reg <= "---";
                bregwrite <= "00";	
                branch <= '0';
                jal <= '0';
                jalr <= '0';
                operation <= "----";
	  
		end case;
	end process;
end maincontrol_arch;
