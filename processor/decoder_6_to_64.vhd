----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 04:39:37 PM
-- Design Name: 
-- Module Name: decoder_6_to_64 - Behavioral
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

entity decoder_6_to_64 is
Port ( sel6 : in STD_LOGIC_VECTOR (5 downto 0);
y : out STD_LOGIC_VECTOR (63 downto 0));
end decoder_6_to_64;

architecture Behavioral of decoder_6_to_64 is

component decoder_3_to_8
Port ( sel3 : in STD_LOGIC_VECTOR (2 downto 0);
en: in STD_LOGIC;
y : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal dec0_out: std_logic_vector(7 downto 0);

begin



de0: decoder_3_to_8 port map (sel3 => sel6(5 downto 3), en => '1', y => dec0_out);
de1: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(0), y => y(7 downto 0));
de2: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(1), y => y(15 downto 8));
de3: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(2), y => y(23 downto 16));
de4: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(3), y => y(31 downto 24));
de5: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(4), y => y(39 downto 32));
de6: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(5), y => y(47 downto 40));
de7: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(6), y => y(55 downto 48));
de8: decoder_3_to_8 port map (sel3 => sel6(2 downto 0), en => dec0_out(7), y => y(63 downto 56));


end Behavioral;
