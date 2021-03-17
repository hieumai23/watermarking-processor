----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 01:02:08 PM
-- Design Name: 
-- Module Name: mem_row_8b - Behavioral
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

entity mem_row_8b is
port(
    w_data: in std_logic_vector (7 downto 0);
    rw_en: in std_logic_vector (1 downto 0);
    clk: in std_logic;
    q: out std_logic_vector (7 downto 0)
);
end mem_row_8b;

architecture Behavioral of mem_row_8b is

component dff
port (
    d: in std_logic;
    clk: in std_logic;
    rw_en: in std_logic_vector (1 downto 0);
    q: out std_logic
);
end component;

begin

dff_gen:
for i in 0 to 7 generate
    dff_x: dff port map (d => w_data(i), clk => clk, rw_en => rw_en, q => q(i));
end generate dff_gen;

end Behavioral;
