----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 01:42:28 PM
-- Design Name: 
-- Module Name: alpha_beta_unit - Behavioral
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

entity alpha_beta_unit is
    generic(n: natural := 8;
            q: natural := 2);
    port(
        i_Imn: in std_logic_vector(n-1 downto 0);
        i_amax: in std_logic_vector(n-1 downto 0);
        i_amin: in std_logic_vector(n-1 downto 0);
        i_bmax: in std_logic_vector(n-1 downto 0);
        i_bmin: in std_logic_vector(n-1 downto 0);
        
        i_reset: in std_logic;
        i_enable: in std_logic;
        
        o_ak: out std_logic_vector(n-1 downto 0);
        o_bk: out std_logic_vector(n-1 downto 0)
    );
end alpha_beta_unit;

architecture Behavioral of alpha_beta_unit is

    component exp_unit is
    generic(n: natural := 8;
            q: natural := 2);
    port (
        i_x: in std_logic_vector(n-1 downto 0);
        o_e: out std_logic_vector(n-1 downto 0)
    );
    end component;

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
    
    component accumulator is
    generic(n: natural:= 8);
    port (
        i_x: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        i_ctrl: in std_logic;
        i_reset: in std_logic;
        i_enable: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0);
        o_cout: out std_logic
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

    signal p_Imn, o_ACC0: std_logic_vector(2*n-1 downto 0);
    signal o_shift0: std_logic_vector(n-1 downto 0);
    signal o_larger_ukI, o_smaller_ukI: std_logic_vector(n-1 downto 0);
    signal o_ADDSUB0, o_EXP: std_logic_vector(n-1 downto 0);

begin

p_Imn <= "00000000" & i_Imn;

-- LEFT SIDE --

AB_ACC0: accumulator
    generic map(2*n)
    port map(p_Imn, '0', '1', i_reset, i_enable, o_ACC0, open);
    
o_shift0 <= "00" & o_ACC0(2*n-1 downto 10);

AB_MUX_larger_ukI_05: MUX21
    generic map(n)
    port map("00100000", o_shift0, o_shift0(3), o_larger_ukI);

AB_MUX_smaller_ukI_05: MUX21
    generic map(n)
    port map(o_shift0, "00100000", o_shift0(3), o_smaller_ukI);

AB_ADDSUB0: addsub
    generic map(n)
    port map(o_larger_ukI, o_smaller_ukI, '0', '0', open, o_ADDSUB0);
    
AB_EXP: exp_unit
    generic map(n, q)
    port map (o_ADDSUB0, o_EXP);
    


---------------------------------------------

-- RIGHT SIDE --



end Behavioral;
