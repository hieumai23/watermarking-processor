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
        generic(n: integer := 8);
        port(
            i_clk: in std_logic;
            i_start: in std_logic;
            i_select: in std_logic;
            
            addr: out std_logic_vector(7 downto 0);        
            in_rw_en: out std_logic_vector(1 downto 0);           
            out_rw_en: out std_logic_vector(1 downto 0);
            datapath_en: out std_logic
            );
    end component;

    component reg_file_8b is
        port(
            addr: in std_logic_vector(5 downto 0);
            w_data: in std_logic_vector (7 downto 0);
            rw_en: in std_logic_vector (1 downto 0);
            r_data: out std_logic_vector(7 downto 0);
            clk: in std_logic
        );
    end component;
    
    signal o_write_data, image_read_data, wmk_read_data, o_read_data: std_logic_vector(7 downto 0);

    signal tmp_addr: std_logic_vector(7 downto 0);
    signal in_rw_en, out_rw_en: std_logic_vector(1 downto 0);
    signal tmp_datapath_en: std_logic;
    signal tmp_edge1, tmp_edge2, tmp_edge3: std_logic_vector(7 downto 0);
    
    type edge_state_type is (S_EDGE0, S_EDGE1, S_EDGE2, S_EDGE3);
    signal edge_state : edge_state_type := S_EDGE0;
    signal next_edge_state : edge_state_type := edge_state;
    signal tmp_Wmn, tmp_output: std_logic_vector(7 downto 0);
begin
              
U_DATAPATH: datapath
    generic map (n) 
    port map (i_Imn => image_read_data,
              i_Imn_m => tmp_edge3,
              i_Imn_n => tmp_edge2,
              i_amplitude_threshold => "10000000",
              i_Wmn => wmk_read_data,
              i_select => i_select,
              i_ai => i_aI,
              i_amax => i_amax,
              i_amin => i_amin,
              i_bmax => i_bmax,
              i_bmin => i_bmin,
              i_clk => i_clk,
              i_reset => i_reset,
              i_enable => tmp_datapath_en,
              o_IWmn => o_write_data);

IMAGE: reg_file_8b
    port map (addr => tmp_addr(5 downto 0),
              w_data => i_Img,
              rw_en => in_rw_en,
              r_data => image_read_data,
              clk => i_clk);
              
WATERMARK: reg_file_8b
    port map (addr => tmp_addr(5 downto 0),
              w_data => i_Wmk,
              rw_en => in_rw_en,
              r_data => wmk_read_data,
              clk => i_clk);

OUTPUT: reg_file_8b
    port map (addr => tmp_addr(5 downto 0),
              w_data => o_write_data,
              rw_en => out_rw_en,
              r_data => o_read_data,
              clk => i_clk);

CTRL: controller
    generic map (n)
    port map (i_clk => i_clk,
              i_start => i_start,
              i_select => i_select,
              addr => tmp_addr,
              in_rw_en => in_rw_en,
              out_rw_en => out_rw_en,
              datapath_en => tmp_datapath_en);
              
process(i_clk)
begin
    if i_clk'event and i_clk = '1' then
        if in_rw_en = "01" then
            if i_select = '1' then
                case edge_state is
                    when S_EDGE0 =>
                        next_edge_state <= S_EDGE1;
                    when S_EDGE1 => -- load the middle pixel
                        tmp_edge1 <= image_read_data;
                        next_edge_state <= S_EDGE2;
                    when S_EDGE2 =>
                        tmp_edge2 <= image_read_data;
                        next_edge_state <= S_EDGE3;
                    when S_EDGE3 =>
                        tmp_edge3 <= image_read_data;
                        next_edge_state <= S_EDGE0;
                end case;
            else
                tmp_edge1 <= image_read_data;
            end if;
        end if;
        
    end if;
    edge_state <= next_edge_state;
end process;

o_Img <= o_write_data;

end Behavioral;
