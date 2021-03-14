----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2021 04:07:30 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
    generic(n: integer := 8);
    port(
        i_Imn: in std_logic_vector(n-1 downto 0);
        i_Imn_m: in std_logic_vector(n-1 downto 0); -- I(m + 1, n)
        i_Imn_n: in std_logic_vector(n-1 downto 0); -- I(m, n + 1)
        i_amplitude_threshold : in std_logic_vector(n-1 downto 0);
        i_Wmn: in std_logic_vector(n-1 downto 0);
        i_select: in std_logic; -- 0 is algorithm 1, 1 is alogorithm 2
        i_ai: in std_logic_vector(n-1 downto 0);
        i_amax: in std_logic_vector(n-1 downto 0);
        i_amin: in std_logic_vector(n-1 downto 0);
        i_bmax: in std_logic_vector(n-1 downto 0);
        i_bmin: in std_logic_vector(n-1 downto 0);
        i_clk: in std_logic;
        i_reset: in std_logic;
        i_enable: in std_logic;
        
        o_IWmn: out std_logic_vector(n-1 downto 0)
        );
end datapath;

architecture Behavioral of datapath is
    
    component alpha_beta_unit is
        generic(n: natural := 8;
                q: natural := 2;
                log_block: natural := 6);
        port(
            i_Imn: in std_logic_vector(n-1 downto 0);
            i_amax: in std_logic_vector(n-1 downto 0);
            i_amin: in std_logic_vector(n-1 downto 0);
            i_bmax: in std_logic_vector(n-1 downto 0);
            i_bmin: in std_logic_vector(n-1 downto 0);
            
            i_clk: in std_logic;
            
            i_reset: in std_logic;
            i_enable: in std_logic;
            
            o_ak: out std_logic_vector(n-1 downto 0);
            o_bk: out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    component edge_detection is     
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
    end component;
    
    component comparator_8b is
        generic(n: integer := 8);
        port(
             A: in std_logic_vector(n-1 downto 0);
             B: in std_logic_vector(n-1 downto 0);
             gt: out std_logic;
             leq: out std_logic
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
    
    component MUX21 is
        generic(n: integer:= 8);
        port(
            i_input1: in std_logic_vector(n-1 downto 0);
            i_input2: in std_logic_vector(n-1 downto 0);
            i_sel: in std_logic;
            o_res: out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    component addsub is
        generic (n: natural:= 8);
        port(
            i_a: in std_logic_vector(n-1 downto 0);
            i_b: in std_logic_vector(n-1 downto 0);
            i_cin: in std_logic;
            i_ctrl: in std_logic;
            o_cout: out std_logic;
            o_z: out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    signal tmp_ak, tmp_bk: std_logic_vector(n-1 downto 0);
    signal tmp_edge: std_logic;
    signal tmp_mux1, tmp_mux2, tmp_mux3, tmp_mux4, tmp_mux5, tmp_mux6: std_logic_vector(n-1 downto 0);
    signal leq_2, leq_64, leq_128, leq_192, lt_256: std_logic;
    signal tmp_reg_file: std_logic_vector(n-1 downto 0);
    signal tmp_mul1, tmp_mul2, tmp_mul3: std_logic_vector(n-1 downto 0);
    
begin

ALPHA_BETA: alpha_beta_unit
    generic map (n => n,
                 q => 2,
                 log_block => 6)
    port map (i_Imn => i_Imn,
              i_amax => i_amax,
              i_amin => i_amin,
              i_bmax => i_bmax,
              i_bmin => i_bmin,
              i_clk => i_clk,
              i_reset => i_reset,
              i_enable => i_enable,
            
              o_ak => tmp_ak,
              o_bk => tmp_bk);

EDGE_DETECT: edge_detection
    generic map (n => n,
                 log_block => 6)
                 
    port map (i_Imn => i_Imn,
              i_Imn_m => i_Imn_m,
              i_Imn_n => i_Imn_n,
              i_amplitude_threshold => i_amplitude_threshold,
              i_reset => i_reset,
              i_enable => i_enable,
              i_clk => i_clk,
              o_edge => tmp_edge);
              
MUX1: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_ak,
              i_input2 => i_amax,
              i_sel => tmp_edge,
              o_res => tmp_mux1);

MUX2: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_bk,
              i_input2 => i_bmin,
              i_sel => tmp_edge,
              o_res => tmp_mux2);

-- Per algorithm 1, compare I(m, n) with 2, 64, 128, 192, and 256
COMPARE1: comparator_8b
    generic map (n => n)
    port map (A => i_Imn,
              B => "00000010",
              gt => open,
              leq => leq_2);

COMPARE2: comparator_8b
    generic map (n => n)
    port map (A => i_Imn,
              B => "01000000",
              gt => open,
              leq => leq_64);
              
COMPARE3: comparator_8b
    generic map (n => n)
    port map (A => i_Imn,
              B => "10000000",
              gt => open,
              leq => leq_128);
              
COMPARE4: comparator_8b
    generic map (n => n)
    port map (A => i_Imn,
              B => "11000000",
              gt => lt_256,
              leq => leq_192);

-- Hardcoded constants for register file
-- First constant: 1/903.3 = 1.10705*10^-3 = 1.10705 * 10^-3
-- Second constant: C1/6.0976, C1 = 0.399644 => 0.06554
-- Third constant: C2/6.0976, C2 = 0.21988 => 0.03606
-- Fourth constant: C3/6.0976, C3 = 0.185746 => 0.03046 
-- Fifth constant: C4/6.0976, C4 = 0.172925 => 0.02835

-- All the constants < 0 => store only the fractional part => 0Q8
-- First constant: 00000001 = 2^-8 = 3.9*10^-3
-- Second constant: 00010001 = 0.06640
-- Third constant: 00001001 = 0.03515
-- Fourth constant: 00001000 = 0.03125
-- Fifth constant: 00000111 = 0.02734

process (i_clk)
begin
    if i_clk = '1' and i_clk'event then
        if leq_2 = '1' then tmp_reg_file <= "00000001";
        elsif leq_64 = '1' then tmp_reg_file <= "00010001";
        elsif leq_128 = '1' then tmp_reg_file <= "00001001";
        elsif leq_192 = '1' then tmp_reg_file <= "00001000";
        else tmp_reg_file <= "00000111";
        end if;
    end if;
end process;

MUX3: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_mux1,
              i_input2 => tmp_reg_file,
              i_sel => i_select,
              o_res => tmp_mux3);

MUX4: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_mux2,
              i_input2 => i_ai,
              i_sel => i_select,
              o_res => tmp_mux4);

-- multiply 8Q0 with 0Q8 gets 8Q8, keep the whole number part

MUL1: array_Multiplier
    generic map (m => n,
                 n => n,
                 q => 0)
    port map (x => i_Imn,
              y => tmp_mux3,
              o => tmp_mul1); 

MUL2: array_Multiplier
    generic map (m => n,
                 n => n,
                 q => 0)
    port map (x => tmp_mux4,
              y => i_Wmn,
              o => tmp_mul2);

MUL3: array_Multiplier
    generic map (m => n,
                 n => n,
                 q => 0)
    port map (x => tmp_mul1,
              y => tmp_mul2,
              o => tmp_mul3);

MUX5: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_mul1,
              i_input2 => i_Imn,
              i_sel => i_select,
              o_res => tmp_mux5);
              
MUX6: MUX21
    generic map (n => n)
    port map (i_input1 => tmp_mul2,
              i_input2 => tmp_mul3,
              i_sel => i_select,
              o_res => tmp_mux6);
              
ADDER: addsub
    generic map (n => n)
    port map (i_a => tmp_mux5,
              i_b => tmp_mux6,
              i_cin => '0',
              i_ctrl => '1', -- add
              o_cout => open,
              o_z => o_IWmn);
             
              
end Behavioral;
