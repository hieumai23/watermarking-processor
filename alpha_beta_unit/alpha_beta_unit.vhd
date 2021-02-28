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
use work.mypackage.all;

entity alpha_beta_unit is
    generic(n: natural := 8;
            q: natural := 2;
            log_block: natural := 8);
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
    
    component div_r4_comb is
      port (
          A: in STD_LOGIC_VECTOR (XBITS-1 downto 0);
          B: in STD_LOGIC_VECTOR (YBITS-1 downto 0);
          Q: out STD_LOGIC_VECTOR (XBITS-1 downto 0);
          R: out STD_LOGIC_VECTOR (YBITS-1 downto 0)
       );
    end component;

    signal p_Imn, o_ACC0: std_logic_vector(2*n-1 downto 0);
    signal mu_ki, c_half: std_logic_vector(n-1 downto 0);
    signal o_SUBABS0, o_EXP: std_logic_vector(n-1 downto 0);
    signal zero_8b: std_logic_vector(n-1 downto 0);
    
    signal Imn_deviation: std_logic_vector(n-1 downto 0);
    signal p_Imn_deviation, o_ACC1: std_logic_vector(2*n-1 downto 0);
    signal sigma_ki: std_logic_vector(n-1 downto 0);
    signal o_ADDSUB1, o_MULT0, o_MULT1, o_MULT2: std_logic_vector(n-1 downto 0);
    signal beta_diff, alpha_diff: std_logic_vector(n-1 downto 0);
    signal o_DIV: std_logic_vector(n-1 downto 0);
    
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

-- output from accumulator divided by 16384 => keep the top 2 bits, pad the rest with 0's
mu_ki <= "000000" & o_ACC0(15 downto 14);
c_half <= (n-q-1 => '1', others => '0');

AB_SUBABS0: sub_abs
    generic map(n)
    port map (
        i_a => mu_ki,
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

AB_ADDSUB1: addsub
    generic map(n)
    port map(
        i_a => "01000000", -- 1.0
        i_b => o_EXP,
        i_cin => '0',
        i_ctrl => '0', -- subtract
        o_cout => open,
        o_z => o_ADDSUB1);

AB_MULT0: array_Multiplier
    generic map(m => n, n => n, q => q)
    port map(
        x => o_ADDSUB1,
        y => sigma_ki,
        o => o_MULT0);

AB_ADDSUB2: addsub
    generic map(n)
    port map(
        i_a => i_bmax,
        i_b => i_bmin,
        i_cin => '0',
        i_ctrl => '0', -- subtract
        o_cout => open,
        o_z => beta_diff);

AB_MULT1: array_Multiplier
    generic map(m => n, n => n, q => q)
    port map(
        x => o_MULT0,
        y => beta_diff,
        o => o_MULT1);

AB_ADDER0: addsub
    generic map(n)
    port map(
        i_a => o_MULT1,
        i_b => i_bmin,
        i_cin => '0',
        i_ctrl => '1', -- add
        o_cout => open,
        o_z => o_bk);

---------------------------------------------

-- RIGHT SIDE --

AB_ADDSUB0: addsub
    generic map(n)
    port map(
        i_a => i_Imn,
        i_b => "10000000", -- 128
        i_cin => '0',
        i_ctrl => '0', -- subtract
        o_cout => open,
        o_z => Imn_deviation);

p_Imn_deviation <= zero_8b & Imn_deviation;
AB_ACC1: accumulator
    generic map(2*n)
    port map(
        i_x => p_Imn_deviation,
        i_cin => '0',
        i_ctrl => '1',
        i_reset => i_reset,
        i_enable => i_enable,
        o_z => o_ACC1,
        o_cout => open);

-- output from accumulator divided by 8192 => keep top 3 bits, pad the rest with 0's
sigma_ki <= "00000" & o_ACC1(15 downto 13);
AB_DIV0: div_r4_comb
    port map (
          A => o_EXP,
          B => sigma_ki,
          Q => o_DIV,
          R => open);

AB_ADDSUB3: addsub
    generic map(n)
    port map(
        i_a => i_amax,
        i_b => i_amin,
        i_cin => '0',
        i_ctrl => '0', -- subtract
        o_cout => open,
        o_z => alpha_diff);
        
AB_MULT2: array_Multiplier
    generic map(m => n, n => n, q => q)
    port map(
        x => o_DIV,
        y => alpha_diff,
        o => o_MULT2);
        
AB_ADDSUB4: addsub
    generic map(n)
    port map(
        i_a => i_amin,
        i_b => o_MULT2,
        i_cin => '0',
        i_ctrl => '1', -- add
        o_cout => open,
        o_z => o_ak);


end Behavioral;
