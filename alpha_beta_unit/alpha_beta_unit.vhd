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
            q: natural := 2;
            log_block: natural := 4);
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

    component sub_abs is
    generic(n: natural:= 8);
    port(
        i_a: in std_logic_vector(n-1 downto 0);
        i_b: in std_logic_vector(n-1 downto 0);
        i_cin: in std_logic;
        o_z: out std_logic_vector(n-1 downto 0)
    );
    end component;

    signal p_Imn, o_ACC0: std_logic_vector(2*n-1 downto 0);
    signal o_shift0, c_half: std_logic_vector(n-1 downto 0);
    signal o_SUBABS0, o_EXP: std_logic_vector(n-1 downto 0);
    signal zero_8b: std_logic_vector(n-1 downto 0);

begin

zero_8b <= (others => '0');
p_Imn <= zero_8b & i_Imn;

-- LEFT SIDE --

AB_ACC0: accumulator
    generic map(2*n)
    port map(
            i_x => p_Imn,
            i_cin => '0',
            i_ctrl => '1',
            i_reset => i_reset,
            i_enable => i_enable,
            o_z => o_ACC0,
            o_cout => open
        );
    
o_shift0 <= "00" & o_ACC0(n+log_block-1 downto log_block+q);
c_half <= (n-q-1 => '1', others => '0');

AB_SUBABS0: sub_abs
    generic map(n)
    port map (
        i_a => o_shift0,
        i_b => c_half,
        i_cin => '0',
        o_z => o_SUBABS0
    );
    
AB_EXP: exp_unit 
    generic map(n, q)
    port map(
        i_x => o_SUBABS0,
        o_e => o_EXP
    );

---------------------------------------------

-- RIGHT SIDE --



end Behavioral;
