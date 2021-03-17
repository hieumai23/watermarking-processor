----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2021 06:06:52 PM
-- Design Name: 
-- Module Name: processor - Behavioral
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

entity processor is
    generic (n: integer := 8);
    port (
        i_clk: in std_logic;
        i_reset: in std_logic;
        i_start: in std_logic;
        i_aI: in std_logic_vector(n-1 downto 0);
        i_bmax: in std_logic_vector(n-1 downto 0);
        i_bmin: in std_logic_vector(n-1 downto 0);
        i_amax: in std_logic_vector(n-1 downto 0);
        i_amin: in std_logic_vector(n-1 downto 0);
        i_select: in std_logic;
        i_Img: in std_logic_vector(n-1 downto 0);
        i_Wmk: in std_logic_vector(n-1 downto 0);
        
        o_Img: out std_logic_vector(n-1 downto 0);
        o_busy: out std_logic;
        o_dataReady: out std_logic
        ); 
end processor;

architecture Behavioral of processor is

    component datapath is
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
    end component;

    component controller is
        port(
            i_clk: in std_logic;
            i_start: in std_logic;
            i_select: in std_logic;
            i_block_completed: in std_logic;
            i_image_completed: in std_logic;
            
            o_init: out std_logic;
            o_read_block: out std_logic;
            o_write_block: out std_logic;
            o_display_image: out std_logic;
            o_write_pixel: out std_logic;
            o_read_pixel: out std_logic
            );
    end component;

    component reg_file_8b is
        port(
            w_addr: in std_logic_vector(5 downto 0);
            w_data: in std_logic_vector (7 downto 0);
            rw_en: in std_logic_vector (1 downto 0);
            r_addr: in std_logic_vector(5 downto 0);
            r_data: out std_logic_vector(7 downto 0);
            clk: in std_logic
        );
    end component;
    
    signal a_write_addr, b_write_addr, o_write_addr, a_read_addr, b_read_addr, o_read_addr: std_logic_vector(5 downto 0);
    signal a_write_data, b_write_data, o_write_data, a_read_data, b_read_data, o_read_data: std_logic_vector(7 downto 0);
    signal a_rw_en, b_rw_en, o_rw_en: std_logic_vector(1 downto 0);

begin
              
U_DATAPATH: datapath
    generic map (n) 
    port map (i_Imn => i_Img,
              i_Imn_m => "00000000",
              i_Imn_n => "00000000",
              i_amplitude_threshold => "00000000",
              i_Wmn => i_Wmk,
              i_select => i_select,
              i_ai => i_aI,
              i_amax => i_amax,
              i_amin => i_amin,
              i_bmax => i_bmax,
              i_bmin => i_bmin,
              i_clk => i_clk,
              i_reset => i_reset,
              i_enable => '1',
              o_IWmn => o_Img);

ALPHA: reg_file_8b
    port map (w_addr => a_write_addr,
              w_data => a_write_data,
              rw_en => a_rw_en,
              r_addr => a_read_addr,
              r_data => a_read_data,
              clk => i_clk);
              
BETA: reg_file_8b
    port map (w_addr => b_write_addr,
              w_data => b_write_data,
              rw_en => b_rw_en,
              r_addr => b_read_addr,
              r_data => b_read_data,
              clk => i_clk);

OUTPUT: reg_file_8b
    port map (w_addr => o_write_addr,
              w_data => o_write_data,
              rw_en => o_rw_en,
              r_addr => o_read_addr,
              r_data => o_read_data,
              clk => i_clk);

CTRL: controller
    port map (i_clk => i_clk,
              i_start => i_start,
              i_select => i_select,
              
              alpha_write_addr => a_write_addr,
              beta_write_addr => b_write_addr,
              out_write_addr => o_write_addr,
              alpha_read_addr => a_read_addr,
              beta_read_addr => b_read_addr,
              out_read_addr => o_read_addr);
              

end Behavioral;
