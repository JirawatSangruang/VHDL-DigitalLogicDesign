LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS

    
    COMPONENT ev_charger_counter
        PORT (
            clk             : IN  STD_LOGIC;
            reset           : IN  STD_LOGIC;
            ev_connected    : IN  STD_LOGIC;
            charging_complete : IN  STD_LOGIC;
            full_charge_count : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    
    SIGNAL clk             : STD_LOGIC := '0';
    SIGNAL reset           : STD_LOGIC := '0';
    SIGNAL ev_connected    : STD_LOGIC := '0';
    SIGNAL charging_complete : STD_LOGIC := '0';

    
    SIGNAL full_charge_count : STD_LOGIC_VECTOR(7 DOWNTO 0);

    
    CONSTANT clk_period : TIME := 10 ns;

    
    SIGNAL sim_finished : BOOLEAN := false;

BEGIN

    
    uut : ev_charger_counter
        PORT MAP (
            clk               => clk,
            reset             => reset,
            ev_connected      => ev_connected,
            charging_complete => charging_complete,
            full_charge_count => full_charge_count
        );

    
    clk_process : PROCESS
    BEGIN
        WHILE NOT sim_finished LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
        WAIT; 
    END PROCESS;

    
    stim_proc : PROCESS
    BEGIN
        
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        WAIT FOR 20 ns;

      
        ev_connected <= '1';
        charging_complete <= '0';
        WAIT FOR 50 ns;
        charging_complete <= '1';
        WAIT FOR 20 ns;
        ev_connected <= '0';
        charging_complete <= '0';
        WAIT FOR 50 ns;

        
        ev_connected <= '1';
        WAIT FOR 40 ns;
        ev_connected <= '0';
        WAIT FOR 50 ns;

       
        ev_connected <= '1';
        charging_complete <= '0';
        WAIT FOR 70 ns;
        charging_complete <= '1';
        WAIT FOR 20 ns;
        ev_connected <= '0';
        charging_complete <= '0';
        WAIT FOR 50 ns;

       
        sim_finished <= true;
        
        
        WAIT;
    END PROCESS;

END;
