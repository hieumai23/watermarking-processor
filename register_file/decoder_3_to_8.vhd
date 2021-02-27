----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 04:36:55 PM
-- Design Name: 
-- Module Name: decoder_3_to_8 - Behavioral
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

entity decoder_3_to_8 is
Port ( 
    sel3 : in STD_LOGIC_VECTOR (2 downto 0);
    en: in STD_LOGIC;
    y : out STD_LOGIC_VECTOR (7 downto 0));
end decoder_3_to_8;

architecture Behavioral of decoder_3_to_8 is

begin

y<=
"00000001" when sel3 = "000" and en = '1' else
"00000010" when sel3 = "001" and en = '1' else
"00000100" when sel3 = "010" and en = '1' else
"00001000" when sel3 = "011" and en = '1' else
"00010000" when sel3 = "100" and en = '1' else
"00100000" when sel3 = "101" and en = '1' else
"01000000" when sel3 = "110" and en = '1' else
"10000000" when sel3 = "111" and en = '1' else
"00000000" when en = '0';

--process(en)
--begin

--if en = '1' then
--    case sel3 is
--    when "000" => y<="00000001";
--    when "001" => y<="00000010";
--    when "010" => y<="00000100";
--    when "011" => y<="00001000";
--    when "100" => y<="00010000";
--    when "101" => y<="00100000";
--    when "110" => y<="01000000";
--    when "111" => y<="10000000";
--    when others => y<="00000000";
--    end case;
--else
--    y <= "00000000";
--end if;

--end process;
end Behavioral;
