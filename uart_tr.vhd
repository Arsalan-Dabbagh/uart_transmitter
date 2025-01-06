---------------------------------------------------------------------------------- 
-- Engineer: Arsalan Dabbagh
-- 
-- Create Date: <Create Date> 
-- Module Name: <Module Name> 
-- Project Name: <Project Name>
-- Description: 
-- 
-- 
-- Dependencies: 
-- <List of any external dependencies or libraries used>
-- 
-- Revision History:
-- Revision 0.01 - File Created
-- <Additional revisions can be added here with details>
-- 
-- Additional Comments:
-- <Any additional notes about the module or design decisions>
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tr is

    generic(
        DATA_WIDTH  : integer   := 8;
        STOP_WIDTH  : integer   := 1;
        START_BIT   : std_logic := '0';
        STOP_BIT    : std_logic := '1'
    );
    
    Port (
        BCLK: in std_logic;
        RST	: in std_logic;
        DIN	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
        TXD	: out std_logic;
        BSY : out std_logic
     );
     
end uart_tr;

architecture Behavioral of uart_tr is

    type state_type is (
    idle_state, 
    start_state, 
    transmit_state,
    stop_state
    );
    
    signal current_state: state_type := idle_state;
    signal next_state: state_type;
    signal data_buf: std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal index_counter: integer range 0 to DATA_WIDTH := 0;

begin


    clock_process: process(BCLK,RST)
    begin
    
        if rising_edge(BCLK) then
            
            case current_state is
                when idle_state =>
                    TXD <= '1';
                    BSY <= '0';
                    if RST = '1' then
                        next_state <= idle_state;
                    elsif RST = '0' then
                        next_state <= start_state;
                    end if;
                     
                when start_state =>
                    TXD <= START_BIT;
                    BSY <= '1';
                    data_buf <= DIN;
                    next_state <= transmit_state;
                        
                when transmit_state => 
                    if index_counter < DATA_WIDTH - 1 then
                        TXD <= data_buf(index_counter);
                        index_counter <= index_counter + 1;
                        next_state <= transmit_state; 
                    elsif index_counter = DATA_WIDTH - 1 then
                        index_counter <= 0;
                        next_state <= stop_state;
                    end if;
                        
                when stop_state =>
                    TXD <= STOP_BIT;
                    BSY <= '0';
                    next_state <= idle_state;
                end case;
                
        end if;
        
    end process;
    
    current_state <= next_state;


end Behavioral;
