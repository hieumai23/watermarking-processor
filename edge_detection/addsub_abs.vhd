----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 07:13:18 PM
-- Design Name: 
-- Module Name: addsub_abs - Behavioral
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

entity sub_abs is
    generic(n: natural:= 8);
    port(
        i_a: in std_logic_vector(n-1 downto 0);
        i_b: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
end sub_abs;

architecture Behavioral of sub_abs is

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

    component MUX21 is
    generic(n: integer:= 8);
    port(
        i_input1: in std_logic_vector(n-1 downto 0);
        i_input2: in std_logic_vector(n-1 downto 0);
        i_sel: in std_logic;
        o_res: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal cout_ADDSUB0, cout_ADDSUB1: std_logic;
    signal c_one, inv_z_ADDSUB0, z_ADDSUB0, z_ADDSUB1: std_logic_vector(n-1 downto 0);

begin

inv_z_ADDSUB0 <= not z_ADDSUB0;
c_one <= (0 => '1', others => '0');

ABS_ADDSUB0: addsub
    generic map(n)
    port map(
        i_a => i_a,
        i_b => i_b,
        i_cin => i_cin,
        i_ctrl => '0',
        o_cout => cout_ADDSUB0,
        o_z => z_ADDSUB0
    );

ABS_ADDSUB1: addsub
    generic map(n)
    port map(
        i_a => inv_z_ADDSUB0,
        i_b => c_one,
        i_cin => '0',
        i_ctrl => '1',
        o_cout => cout_ADDSUB1,
        o_z => z_ADDSUB1
    );

ABS_MUX: MUX21
    generic map(n)
    port map(
        i_input1 => z_ADDSUB0,
        i_input2 => z_ADDSUB1,
        i_sel => cout_ADDSUB0,
        o_res => o_z
    );

end Behavioral;
