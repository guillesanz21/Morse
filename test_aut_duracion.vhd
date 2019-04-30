-----------------------------------------------------------------
--   Dpto. de Ingeniería Electrónica, ETSI Telecomunicación
--   Universidad Politécnica de Madrid
--
---------------
-- 
-- Test para el autómata medidor de duración
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_aut_duracion IS
END test_aut_duracion;
 
ARCHITECTURE behavior OF test_aut_duracion IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT aut_duracion
    PORT(
         CLK_1ms : IN  std_logic;
         ENTRADA : IN  std_logic;
         VALID : OUT  std_logic;
         DATO : OUT  std_logic;
         DURACION : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1ms : std_logic := '0';
   signal ENTRADA : std_logic := '0';

 	--Outputs
   signal VALID : std_logic;
   signal DATO : std_logic;
   signal DURACION : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_1ms_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: aut_duracion PORT MAP (
          CLK_1ms => CLK_1ms,
          ENTRADA => ENTRADA,
          VALID => VALID,
          DATO => DATO,
          DURACION => DURACION
        );

   -- Clock process definitions
   CLK_1ms_process :process
   begin
		CLK_1ms <= '0';
		wait for CLK_1ms_period/2;
		CLK_1ms <= '1';
		wait for CLK_1ms_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	   ENTRADA<='0';
      wait for 100 ns;	

      ENTRADA<='1';
      wait for 300 ns;	
		ENTRADA<='0';
      wait for 100 ns;	
		ENTRADA<='1';
      wait for 100 ns;	
		ENTRADA<='0';
      wait for 300 ns;	
		ENTRADA<='1';
      wait for 300 ns;	
		ENTRADA<='0';
      wait for 100 ns;	
		ENTRADA<='1';
      wait for 100 ns;	
		ENTRADA<='0';
		wait for 700 ns;
 
      
      wait;
   end process;

END;
