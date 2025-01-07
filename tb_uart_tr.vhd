----------------------------------------------------------------------------------
-- Engineer: Arsalan Dabbagh
-- 
-- Create Date: 06/01/2025
-- Module Name: tb_uart_tr
-- Project Name: uart_transmitter
-- Description: 
-- Testbench for UART transmitter.  
-- 
--
-- Dependencies:
-- - IEEE.STD_LOGIC_1164 
-- - IEEE.NUMERIC_STD 
--
-- 
-- Revision History:
-- Revision 0.01 - File Created
-- 
-- 
-- Additional Comments:
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_uart_tr is
--  Port ( );
end tb_uart_tr;

architecture Behavioral of tb_uart_tr is

    component uart_tr is
        generic(
            DATA_WIDTH  : integer   := 8;
            STOP_WIDTH  : integer   := 1;
            START_BIT   : std_logic := '0';
            STOP_BIT    : std_logic := '1'
        );
    
        Port (
            BCLK: in std_logic;
            RST : in std_logic;
            DIN : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            TXD : out std_logic;
            BSY : out std_logic
            );
    end component;
    
    signal BCLK : std_logic := '0';
    signal RST  : std_logic := '0';
    signal DIN  : std_logic_vector(7 downto 0) := "11001100";
    signal TXD  : std_logic := '1';
    signal BSY  : std_logic;
    
    -- Constants
    constant DATA_WIDTH : integer := 8;
    constant CLK_PERIOD : time := 10 ns;
        
begin

    uut: uart_tr 
    port map(
        BCLK    =>  BCLK,
        RST     =>  RST,
        DIN     =>  DIN,
        TXD     =>  TXD,
        BSY     =>  BSY
    );


    -- Clock generation process
    clock_process: process
    begin
        while true loop
            BCLK <= '0';
            wait for CLK_PERIOD / 2;
            BCLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset the system
        RST <= '1';
        wait for 2 * CLK_PERIOD;
        RST <= '0';

        -- Test Case 1: Transmit a byte
        DIN <= "00001111"; -- Example data
        wait for 10 * CLK_PERIOD;

        -- Test Case 2: Transmit another byte
        DIN <= "11001100"; -- Example data
        wait for 10 * CLK_PERIOD;

        -- Test Case 3: Reset during operation
        RST <= '1';
        wait for 2 * CLK_PERIOD;
        RST <= '0';

        -- End simulation
        wait;
    end process;


end Behavioral;
