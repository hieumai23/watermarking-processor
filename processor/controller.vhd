----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2021 02:28:46 PM
-- Design Name: 
-- Module Name: controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    generic(n: integer := 8);
    port(
        i_clk: in std_logic;
        i_start: in std_logic;
        i_select: in std_logic;
        
        addr: out std_logic_vector(7 downto 0);
        in_rw_en: out std_logic_vector(1 downto 0);
        out_rw_en: out std_logic_vector(1 downto 0);
        datapath_en: out std_logic
        );
end controller;

architecture Behavioral of controller is
    
    component addsub is
        generic (n: natural:= 8);
        port(
            i_a: in std_logic_vector(n-1 downto 0);
            i_b: in std_logic_vector(n-1 downto 0);
            i_cin: in std_logic;
            i_ctrl: in std_logic;
            o_cout: out std_logic;
            o_z: out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    type state_type is (S_INIT, S_ALGO1, S_READ_BLOCK, S_COMPUTE_BLOCK, S_WRITE_BLOCK, S_DISPLAY_IMAGE);
    signal display_completed, compute_block_completed, write_block_completed, read_block_completed: std_logic := '0';
    signal curr_state : state_type := S_INIT;
    signal next_state : state_type := curr_state;
    signal tmp_index, reg_file_index: std_logic_vector(7 downto 0) := "00000000";
    
    type edge_state_type is (S_EDGE1, S_EDGE2, S_EDGE3, S_EDGE4);
    signal edge_state : edge_state_type := S_EDGE1;
    signal next_edge_state : edge_state_type := edge_state;
    signal edge_detect_n, edge_detect_m: std_logic_vector(7 downto 0);
    
begin

ADDSUB1: addsub
    generic map (n)
    port map (i_a => reg_file_index,
              i_b => "00000001",
              i_cin => '0',
              i_ctrl => '1', -- add
              o_cout => open,
              o_z => tmp_index);

ADDSUB2: addsub
    generic map (n)
    port map (i_a => reg_file_index,
              i_b => "00000001",
              i_cin => '0',
              i_ctrl => '1', -- add
              o_cout => open,
              o_z => edge_detect_n);
              
ADDSUB3: addsub
    generic map (n)
    port map (i_a => reg_file_index,
              i_b => "00001000",
              i_cin => '0',
              i_ctrl => '1', -- add
              o_cout => open,
              o_z => edge_detect_m);

process(i_clk)
begin
    if i_clk'event and i_clk = '1' then
        case curr_state is
            when S_INIT =>
                compute_block_completed <= '0';
                write_block_completed <= '0';
                read_block_completed <= '0';
                display_completed <= '0';
                reg_file_index <= "00000000";
                in_rw_en <= "00";
                out_rw_en <= "00";
                datapath_en <= '0';
                if i_start = '0' then next_state <= S_INIT;
                else next_state <= S_READ_BLOCK;
                end if;
            when S_READ_BLOCK =>    
                addr <= reg_file_index;
                in_rw_en <= "10"; -- write
                if reg_file_index = "00111111" then
                    read_block_completed <= '1';
                    reg_file_index <= "00000000";
                else
                    reg_file_index <= tmp_index;
                end if;
                
                if read_block_completed = '0' then next_state <= S_READ_BLOCK;
                else
                    reg_file_index <= "00000000"; 
                    if i_select = '0'then
                        next_state <= S_ALGO1;
                    else 
                        next_state <= S_COMPUTE_BLOCK;
                    end if;
                end if;
                
            when S_COMPUTE_BLOCK =>
                -- compute alpha beta and edge detection
                in_rw_en <= "01"; -- read
                case edge_state is
                    when S_EDGE1 => 
                        datapath_en <= '0';
                        addr <= reg_file_index;
                        next_edge_state <= S_EDGE2;
                        
                        if reg_file_index = "00110110" then
                            compute_block_completed <= '1';
                            reg_file_index <= "00000000";
                        elsif reg_file_index = "00000111" then
                            reg_file_index <= "00001000";
                        elsif reg_file_index = "00001111" then
                            reg_file_index <= "00010000";
                        elsif reg_file_index = "00010111" then
                            reg_file_index <= "00011000";
                        elsif reg_file_index = "00011111" then
                            reg_file_index <= "00100000";
                        elsif reg_file_index = "00100111" then
                            reg_file_index <= "00101000";
                        elsif reg_file_index = "00101111" then
                            reg_file_index <= "00110000";
                        else
                            reg_file_index <= tmp_index;
                        end if;
                        
                        if compute_block_completed =  '0' then next_state <= S_COMPUTE_BLOCK;
                        else 
                            reg_file_index <= "00000000"; 
                            next_state <= S_WRITE_BLOCK;
                        end if;              
                    when S_EDGE2 =>
                        addr <= edge_detect_n;
                        next_edge_state <= S_EDGE3;
                    when S_EDGE3 =>
                        addr <= edge_detect_m;
                        next_edge_state <= S_EDGE4;
                    when S_EDGE4 =>
                        datapath_en <= '1';
                        next_edge_state <= S_EDGE1;
                end case;
               
            when S_WRITE_BLOCK =>
                out_rw_en <= "10"; -- write
                in_rw_en <= "00";
                addr <= reg_file_index;
                if reg_file_index = "00111111" then
                    write_block_completed <= '1';
                    reg_file_index <= "00000000";
                else
                    reg_file_index <= tmp_index;
                end if;
                
                if write_block_completed = '0' then next_state <= S_WRITE_BLOCK;
                else 
                    reg_file_index <= "00000000"; 
                    next_state <= S_DISPLAY_IMAGE;
                end if;
            when S_DISPLAY_IMAGE =>
--                out_rw_en <= "01"; -- read
--                if reg_file_index = "00111111" then
--                    display_completed <= '1';
--                    reg_file_index <= "00000000";
--                else
--                    reg_file_index <= tmp_index;
--                end if;
                
--                if display_completed = '0' then next_state <= S_DISPLAY_IMAGE;
--                else next_state <= S_INIT;
--                end if;
                next_state <= S_INIT;
                
            when S_ALGO1 =>
                in_rw_en <= "01"; -- 
                addr <= reg_file_index;
                if reg_file_index = "00111111" then
                    compute_block_completed <= '1';
                    reg_file_index <= "00000000";
                else
                    reg_file_index <= tmp_index;
                end if;
                
                if compute_block_completed =  '0' then next_state <= S_ALGO1;
                else
                    reg_file_index <= "00000000";  
                    next_state <= S_WRITE_BLOCK;
                end if;
        end case;
    end if;
    curr_state <= next_state;
    edge_state <= next_edge_state; 
end process;

end Behavioral;
