  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  
  ENTITY ev_charger_counter IS
      PORT (
          clk             : IN  STD_LOGIC; 
          reset           : IN  STD_LOGIC; 
          ev_connected    : IN  STD_LOGIC;
          charging_complete : IN  STD_LOGIC; 
          full_charge_count : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
      );
  END ev_charger_counter;

 
  ARCHITECTURE fsm OF ev_charger_counter IS

     
      TYPE state_type IS (S_IDLE, S_CHARGING, S_FULLY_CHARGED, S_WAIT_FOR_DISCONNECT);

      
      SIGNAL current_state, next_state : state_type;

      
      SIGNAL count_internal : UNSIGNED(7 DOWNTO 0);

  BEGIN

     
      state_memory_process : PROCESS (clk, reset)
      BEGIN
          IF reset = '1' THEN
              current_state <= S_IDLE; 
          ELSIF rising_edge(clk) THEN
              current_state <= next_state;
          END IF;
      END PROCESS;

      
      state_transition_logic : PROCESS (current_state, ev_connected, charging_complete)
      BEGIN
          
          next_state <= current_state;

          CASE current_state IS
              WHEN S_IDLE =>
                  
                  IF ev_connected = '1' THEN
                      next_state <= S_CHARGING;
                  END IF;

              WHEN S_CHARGING =>
                  
                  IF charging_complete = '1' THEN
                      next_state <= S_FULLY_CHARGED;
                  
                  ELSIF ev_connected = '0' THEN
                      next_state <= S_IDLE;
                  END IF;

              WHEN S_FULLY_CHARGED =>
                  
                  IF ev_connected = '0' THEN
                      next_state <= S_IDLE;
                  ELSE
                      
                      next_state <= S_WAIT_FOR_DISCONNECT;
                  END IF;

              WHEN S_WAIT_FOR_DISCONNECT =>
                  
                  IF ev_connected = '0' THEN
                      next_state <= S_IDLE;
                  END IF;

          END CASE;
      END PROCESS;

     
      output_and_counter_logic : PROCESS (clk, reset)
      BEGIN
          IF reset = '1' THEN
              count_internal <= (OTHERS => '0'); 
          ELSIF rising_edge(clk) THEN
             
              IF current_state = S_CHARGING AND next_state = S_FULLY_CHARGED THEN
                  count_internal <= count_internal + 1;
              END IF;
          END IF;
      END PROCESS;

      
      full_charge_count <= STD_LOGIC_VECTOR(count_internal);

  END fsm;
