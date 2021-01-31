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
    port(clk: in std_logic;
         start: in std_logic;
         selection: in std_logic;
         block_completed: in std_logic;
         image_completed: in std_logic;
         init: out std_logic;
         read_block: out std_logic;
         write_block: out std_logic;
         display_image: out std_logic;
         write_pixel: out std_logic;
         read_pixel: out std_logic
     );
end controller;

architecture Behavioral of controller is

type state_type is (S_INIT, S_READ_BLOCK, S_WRITE_BLOCK, S_DISPLAY_IMAGE, S_WRITE_PIXEL, S_READ_PIXEL);
signal curr_state : state_type := S_INIT;
signal next_state : state_type := curr_state;

begin

process(clk)
begin
    if clk'event and clk = '1' then
        case curr_state is
            when S_INIT =>
                if start = '0' then next_state <= S_INIT;
                elsif selection = '0' then next_state <= S_READ_PIXEL;
                else next_state <= S_READ_BLOCK;
                end if;
            when S_READ_BLOCK =>
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
