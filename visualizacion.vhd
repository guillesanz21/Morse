----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:36:08 11/06/2018 
-- Design Name: 
-- Module Name:    visualizacion - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity visualizacion is
    Port ( E0 : in  STD_LOGIC_VECTOR (7 downto 0);
           EN : in  STD_LOGIC;
           CLK_1ms : in  STD_LOGIC;
           SEG7 : out  STD_LOGIC_VECTOR (0 to 6);
           AN : out  STD_LOGIC_VECTOR (3 downto 0));
end visualizacion;

architecture Behavioral of visualizacion is

component MUX4x8
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0);	-- Codigo 0
		E1 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 1
		E2 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 2
		E3 : in STD_LOGIC_VECTOR (7 downto 0); 		-- Codigo 3
		S : in STD_LOGIC_VECTOR (1 downto 0); 			-- Señal de control
		Y : out STD_LOGIC_VECTOR (7 downto 0)); 		-- Salida (codigo seleccionado)
end component;

component decodmorsea7s
	Port ( SIMBOLO : in STD_LOGIC_VECTOR (7 downto 0);		-- El codigo a representar
		SEGMENTOS : out STD_LOGIC_VECTOR (0 to 6));			-- Los segmentos de los displays
end component;

component refresco
	Port ( CLK_1ms : in STD_LOGIC; 					-- reloj de 1 KHz
		S : out STD_LOGIC_VECTOR (1 downto 0); 	-- Control para el mux
		AN : out STD_LOGIC_VECTOR (3 downto 0)); 	-- Control displays
end component;

component rdesp_disp
	Port ( CLK_1ms : in STD_LOGIC; 					-- entrada de reloj
		EN : in STD_LOGIC; 								-- enable
		E  : in STD_LOGIC_VECTOR (7 downto 0); 	-- entrada de datos 
		Q0 : out STD_LOGIC_VECTOR (7 downto 0);	-- salida Q0
		Q1 : out STD_LOGIC_VECTOR (7 downto 0);	-- salida Q1
		Q2 : out STD_LOGIC_VECTOR (7 downto 0);	-- salida Q2
		Q3 : out STD_LOGIC_VECTOR (7 downto 0));	-- salida Q3
end component;
signal refresco_S: std_logic_vector (1 downto 0);
signal desp_Q0, desp_Q1, desp_Q2, desp_Q3, mux_Y: std_logic_vector (7 downto 0);


begin

-- Mapeo

U0: rdesp_disp port map (CLK_1ms, EN, E0, desp_Q0, desp_Q1, desp_Q2, desp_Q3);
U1: MUX4x8 port map (desp_Q0, desp_Q1, desp_Q2, desp_Q3, refresco_S, mux_Y);
U2: refresco port map (CLK_1ms, refresco_S, AN);
U3: decodmorsea7s port map (mux_Y , SEG7);


end Behavioral;

