library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity instructionCounter is
port (
    clock: in std_logic;
    reset: in std_logic;
    inst: in std_logic_vector(31 downto 0); 
    -- TIPO R  opcode:0110011
    add_counter: out std_logic_vector(31 downto 0); 
    sub_counter: out std_logic_vector(31 downto 0); 
    slt_counter: out std_logic_vector(31 downto 0);
    and_counter: out std_logic_vector(31 downto 0); 
    or_counter: out std_logic_vector(31 downto 0); 
    -- TIPO I opcode:0000011
    lw_counter: out std_logic_vector(31 downto 0);
    -- TIPO S opcode:0100011
    sw_counter: out std_logic_vector(31 downto 0); 
    -- TIPO B opcode:1100011
    beq_counter: out std_logic_vector(31 downto 0); 
    -- TIPO J opcode:1101111
    jal_counter: out std_logic_vector(31 downto 0)
);
end entity instructionCounter;

architecture Counter of instructionCounter is 
    signal opcode: std_logic_vector(6 downto 0);
    signal funct3: std_logic_vector(2 downto 0);
    signal funct7: std_logic_vector(6 downto 0);
    signal cnt: std_logic_vector(31 downto 0);
begin
    opcode <= inst(6 downto 0);
    funct3 <= inst(14 downto 12);
    funct7 <= inst(31 downto 25);

    count : process (all)
    begin 
        if reset = '1' then 
        add_counter <= "00000000000000000000000000000000"; 
        sub_counter <= "00000000000000000000000000000000"; 
        slt_counter <= "00000000000000000000000000000000"; 
        and_counter <= "00000000000000000000000000000000"; 
        or_counter  <= "00000000000000000000000000000000"; 
        lw_counter  <= "00000000000000000000000000000000"; 
        sw_counter  <= "00000000000000000000000000000000"; 
        beq_counter <= "00000000000000000000000000000000";  
        jal_counter <= "00000000000000000000000000000000"; 
        
        elsif rising_edge(clock) then
            case opcode is
                -- TIPO R
                when "0110011" =>
                    case funct3 is
                        -- Para add e sub
                        when "000" =>
                            if funct7 = "0000000" then --add
                                add_counter <= add_counter + 1;
                            else -- sub
                                sub_counter <= sub_counter + 1;
                            end if;
                        -- Para slt
                        when "010" =>
                            slt_counter <= slt_counter + 1;
                        -- Para or
                        when "110" =>
                            or_counter <= or_counter + 1;
                        -- Para and
                        when others =>
                            and_counter <= and_counter + 1;
                    end case;
                -- TIPO I
                when "0000011" =>
                    case funct3 is
                        when "010" =>
							lw_counter<=cnt + 1 ;
                        when others =>
                    end case;
                -- TIPO S
                when "0100011" =>
                    case funct3 is
                        when "010" =>
                            sw_counter <= sw_counter + 1;
                        when others =>
                    end case;
                -- TIPO B
                when "1100011" =>
                    case funct3 is
                        when "000" =>
                            beq_counter <= beq_counter + 1;
                        when others =>
                    end case;
                -- TIPO J
                when others =>
                    jal_counter <= jal_counter + 1;

            end case;

        end if;
    end process;

end Counter;