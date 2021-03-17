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
    port(
        i_clk: in std_logic;
        i_start: in std_logic;
        i_select: in std_logic;
        
        alpha_write_addr: out std_logic_vector(7 downto 0);
        beta_write_addr: out std_logic_vector(7 downto 0);
        out_write_addr: out std_logic_vector(7 downto 0);
        alpha_read_addr: out std_logic_vector(7 downto 0);
        beta_read_addr: out std_logic_vector(7 downto 0);
        out_read_addr: out std_logic_vector(7 downto 0)
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

type state_type is (S_INIT, S_READ_BLOCK, S_WRITE_BLOCK, S_DISPLAY_IMAGE, S_WRITE_PIXEL, S_READ_PIXEL);
signal block_completed, image_completed: std_logic := '0';
signal curr_state : state_type := S_INIT;
signal next_state : state_type := curr_state;
signal reg_file_index: std_logic_vector(5 downto 0) := "000000"; 

begin

process(i_clk)
begin
   if i_clk'event and i_clk = '1' then
        case curr_state is
            when S_INIT =>
                if i_start = '0' then next_state <= S_INIT;
                elsif i_select = '0' then next_state <= S_READ_PIXEL;
                else next_state <= S_READ_BLOCK;
                end if;
            when S_READ_BLOCK =>            
                alpha_write_addr <= reg_file_index;
                beta_write_addr <= reg_file_index;
                
                reg_file_index <= reg_file_index + 1;    
                if block_completed = '0' then next_state <= S_READ_BLOCK;
                else next_state <= S_WRITE_BLOCK;
                end if;
                
                
            when S_WRITE_BLOCK =>
                if block_completed = '0' then next_state <= S_WRITE_BLOCK;
                elsif image_completed = '0' then next_state <= S_READ_BLOCK;
                else next_state <= S_DISPLAY_IMAGE;
                end if;
            when S_DISPLAY_IMAGE =>
                if image_completed = '0' then next_state <= S_DISPLAY_IMAGE;
                else next_state <= S_INIT;
                end if;
            when S_READ_PIXEL =>
                next_state <= S_WRITE_PIXEL;
            when S_WRITE_PIXEL =>
                if image_completed = '0' then next_state <= S_READ_PIXEL;
                else next_state <= S_DISPLAY_IMAGE;
                end if;
        end case;
    end if;
    curr_state <= next_state;
end process;

end Behavioral;
