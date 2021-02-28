----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 08:44:57 PM
-- Design Name: 
-- Module Name: edge_detection - Behavioral
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

entity edge_detection is
    generic(n: integer := 8;
            log_block: integer:= 6);
    port(
        i_Imn: in std_logic_vector(n-1 downto 0);
        i_Imn_m: in std_logic_vector(n-1 downto 0); -- I(m + 1, n)
        i_Imn_n: in std_logic_vector(n-1 downto 0); -- I(m, n + 1)
        
        i_amplitude_threshold: in std_logic_vector(n-1 downto 0);
        
        i_reset: in std_logic;
        i_enable: in std_logic;
        i_clk: in std_logic;
        
        o_edge: out std_logic -- edge or non-edge block
        );

end edge_detection;

architecture Behavioral of edge_detection is
    
    component comparator_8b is
        generic(n: integer := 8);
        port(
             A: in std_logic_vector(n-1 downto 0);
             B: in std_logic_vector(n-1 downto 0);
             geq: out std_logic;
             lt: out std_logic
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
            i_clk: in std_logic;
            o_z: out std_logic_vector(n-1 downto 0);
            o_cout: out std_logic
        );
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
    
    component array_Multiplier is 
        generic (m: natural := 8; 
                 n: natural := 8;
                 q: natural := 2); 
        port( x : in std_logic_vector(m-1 downto 0);
              y : in std_logic_vector(n-1 downto 0); 
              o : out std_logic_vector(m-1 downto 0) ); 
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

    signal left_addsub, right_addsub, g_mn, g_mu: std_logic_vector(n-1 downto 0);
    signal padded_gmn, accum_tmp: std_logic_vector(2*n-1 downto 0);
    signal cout_gmn: std_logic;
    
begin

ADDSUB_1: sub_abs -- only perform subtraction then absolute
    generic map(n)
    port map(i_a => i_Imn_m, -- I(m + 1, n)
             i_b => i_Imn,
             i_cin => '0',
             o_z => left_addsub);

ADDSUB_2: sub_abs
    generic map(n)
    port map(i_a => i_Imn,
             i_b => i_Imn_n, -- I(m, n + 1)
             i_cin => '0',
             o_z => right_addsub);

ADDER_1: addsub
    generic map(n)
    port map(i_a => left_addsub,
             i_b => right_addsub,
             i_cin => '0',
             i_ctrl => '1',
             o_cout => cout_gmn,
             o_z => g_mn);
             
-- padded_gmn <= "0000000" & cout_gmn & g_mn;
padded_gmn(2*n-1 downto n+1) <= (others => '0');
padded_gmn(n) <= cout_gmn;
padded_gmn(n-1 downto 0) <= g_mn;

ACCUMULATOR_1: accumulator
    generic map(2 * n)
    port map(i_x => padded_gmn,
             i_cin => '0',
             i_ctrl => '1',
             i_reset => i_reset,
             i_enable => i_enable,
             i_clk => i_clk,
             o_z => accum_tmp,
             o_cout => open);

-- g_mu <= "000000" & accum_tmp(2*n-1 downto 2*n-10);
g_mu <= accum_tmp(n+log_block-1 downto log_block);

COMPARE: comparator_8b
    generic map(n)
    port map(A => g_mu,
             B => i_amplitude_threshold,
             geq => o_edge,
             lt => open);
    
end Behavioral;
