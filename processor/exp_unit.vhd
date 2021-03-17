----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 01:07:36 PM
-- Design Name: 
-- Module Name: exp_unit - Behavioral
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

entity exp_unit is
    generic(n: natural := 8;
            q: natural := 2);
    port (
        i_x: in std_logic_vector(n-1 downto 0);
        o_e: out std_logic_vector(n-1 downto 0)
    );
end exp_unit;

architecture Behavioral of exp_unit is
    component array_Multiplier is 
    generic (m: natural := 8; 
             n: natural := 8;
             q: natural := 2); 
    port( x : in std_logic_vector(m-1 downto 0);
          y : in std_logic_vector(n-1 downto 0); 
          o : out std_logic_vector(m-1 downto 0) ); 
    end component; 

    component addsub is
    generic(n: natural := 8);
    port (
        i_a: in std_logic_vector(n-1 downto 0);
        i_b: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        i_ctrl: in std_logic;
        o_cout: out std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal c_one, c_half: std_logic_vector(n-1 downto 0);
    signal o_EMULT0, o_EMULT1: std_logic_vector(n-1 downto 0);
    signal o_EADD0: std_logic_vector(n-1 downto 0);

begin
c_one <= (n-q => '1', others => '0');
c_half <= (n-q-1 => '1', others => '0');

EMULT0: array_Multiplier
    generic map(n, n, q)
    port map(i_x, i_x, o_EMULT0);
    
EMULT1: array_Multiplier
    generic map(n, n, q)
    port map(c_half, o_EMULT0, o_EMULT1);
    
EADD0: addsub
    generic map(n)
    port map(o_EMULT1, i_x, '0', '1', open, o_EADD0);
    
EADD1: addsub
    generic map(n)
    port map(o_EADD0, c_one, '0', '1', open, o_e);

end Behavioral;
