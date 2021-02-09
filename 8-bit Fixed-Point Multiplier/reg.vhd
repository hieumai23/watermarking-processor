----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2021 05:26:44 PM
-- Design Name: 
-- Module Name: reg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    generic(n: natural:= 8);
    port(
        i_data: in std_logic_vector(n-1 downto 0);
        o_data: out std_logic_vector(n-1 downto 0);
        i_clk: in std_logic;
        i_load: in std_logic;
        i_shift: in std_logic;
        i_clear: in std_logic;
        i_serIn: in std_logic
    );
end reg;

architecture Behavioral of reg is
    signal temp: std_logic_vector(n-1 downto 0);
begin
    process(i_clk)
    begin
        if i_clk = '1' and i_clk'event then
            if i_clear = '1' then 
                temp <= (others => '0');
            elsif i_load = '1' then 
                temp <= i_data;
            elsif i_shift = '1' then
                temp <= i_serIn & temp(n-1 downto 1);
            end if;
        end if;
    end process;
    o_data <= temp;
end Behavioral;
