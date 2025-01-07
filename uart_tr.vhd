----------------------------------------------------------------------------------
-- Engineer: Arsalan Dabbagh
-- 
-- Create Date: 06/01/2025
-- Module Name: uart_tr
-- Project Name: uart_transmitter
-- Description: 
-- This module implements a UART transmitter for serial communication.  
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
-- - Ensure that the input clock (BCLK) meets the required baud rate for 
--   proper UART operation.
--
--
-- Licensed under the CERN-OHL-P v2.0.
-- See the LICENSE file or https://cern.ch/cern-ohl-p for detailsS
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_tr is
    generic(
        DATA_WIDTH  : integer   := 8;    -- Width of the data to be transmitted
        STOP_WIDTH  : integer   := 1;    -- Width of the stop bit (not used explicitly here)
        START_BIT   : std_logic := '0';  -- Value of the start bit
        STOP_BIT    : std_logic := '1'   -- Value of the stop bit
    );
    
    port (
        BCLK: in std_logic;                           -- Input clock signal
        RST	: in std_logic;                           -- Reset signal
        DIN	: in std_logic_vector(DATA_WIDTH - 1 downto 0); -- Input data to transmit
        TXD	: out std_logic;                          -- Transmitted serial data output
        BSY : out std_logic                           -- Busy signal to indicate transmission is active
    );
end uart_tr;


architecture Behavioral of uart_tr is

    -- Enumeration for FSM states
    type state_type is (
        idle_state,      -- Idle state
        start_state,     -- Start bit transmission state
        transmit_state,  -- Data transmission state
        stop_state       -- Stop bit transmission state
    );
    
    signal current_state: state_type := idle_state;    -- Current state of the FSM
    signal next_state: state_type;                     -- Next state of the FSM
    signal data_buf: std_logic_vector(DATA_WIDTH - 1 downto 0); -- Buffer to hold input data
    signal index_counter: integer range 0 to DATA_WIDTH := 0;   -- Counter for data bit transmission

begin

    -- Process to handle the FSM and data transmission
    clock_process: process(BCLK, RST)
    begin
        -- Detect rising edge of the clock
        if rising_edge(BCLK) then
            
            -- FSM state handling
            case current_state is
                -- Idle state: No transmission; waiting for reset or start signal
                when idle_state =>
                    TXD <= '1';         -- Default high line (idle state for UART)
                    BSY <= '0';         -- Not busy
                    if RST = '0' then
                        next_state <= idle_state;  -- Stay in idle if reset is active
                    elsif RST = '1' then
                        next_state <= start_state; -- Transition to start state on reset release
                    end if;
                     
                -- Start state: Transmit start bit and prepare for data transmission
                when start_state =>
                    TXD <= START_BIT;   -- Transmit the start bit
                    BSY <= '1';         -- Mark as busy
                    data_buf <= DIN;    -- Load input data into buffer
                    next_state <= transmit_state; -- Move to data transmission state
                        
                -- Data transmission state: Transmit data bits serially
                when transmit_state => 
                    if index_counter < DATA_WIDTH - 1 then
                        TXD <= data_buf(index_counter);  -- Transmit the current data bit
                        index_counter <= index_counter + 1; -- Increment the bit counter
                        next_state <= transmit_state;    -- Stay in the same state
                    elsif index_counter = DATA_WIDTH - 1 then
                        index_counter <= 0;             -- Reset the counter
                        next_state <= stop_state;       -- Transition to stop state
                    end if;
                        
                -- Stop state: Transmit stop bit and return to idle
                when stop_state =>
                    TXD <= STOP_BIT;   -- Transmit the stop bit
                    BSY <= '0';        -- Clear busy signal
                    next_state <= idle_state; -- Return to idle state
            end case;
        end if;
    end process;
    
    -- Update the current state with the next state
    current_state <= next_state;

end Behavioral;

