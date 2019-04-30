----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:24 11/20/2018 
-- Design Name: 
-- Module Name:    receptor - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receptor is
	Port ( CLK : in STD_LOGIC; -- reloj de la FPGA
		LIN : in STD_LOGIC; -- Línea de entrada de datos
		BTN3 : in STD_LOGIC;	-- Boton 3
		SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
		AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación individual
		LED1 : out STD_LOGIC);	-- Led 1
end receptor;

architecture a_receptor of receptor is

constant UMBRAL0 : STD_LOGIC_VECTOR (15 downto 0) := "0000000011001000"; -- 200 umbral ceros
constant UMBRAL1 : STD_LOGIC_VECTOR (15 downto 0) := "0000000011001000"; -- 200 umbral unos
constant UMBRAL2 : STD_LOGIC_VECTOR (15 downto 0) := "0000000111110100"; -- 500 umbral ceros

component div_reloj
	Port ( CLK : in STD_LOGIC;
		CLK_1ms : out STD_LOGIC);
end component;

component detector_flanco
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
		LIN : in STD_LOGIC; -- Línea de datos
		VALOR : out STD_LOGIC); -- Valor detectado en el flanco
end component;

component aut_duracion
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de 1 ms
		ENTRADA : in STD_LOGIC; -- línea de entrada de datos
		VALID : out STD_LOGIC; -- salida de validación de dato
		DATO : out STD_LOGIC; -- salida de dato (0 o 1)
		DURACION : out STD_LOGIC_VECTOR (15 downto 0)); -- salida de duración del dato
end component;

component comp_16
	Port ( P : in STD_LOGIC_VECTOR (15 downto 0);
		Q : in STD_LOGIC_VECTOR (15 downto 0);
		P_GT_Q : out STD_LOGIC);
end component;

component aut_control
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
		VALID : in STD_LOGIC; -- entrada de dato válido
		DATO : in STD_LOGIC; -- dato (0 o 1)
		C0 : in STD_LOGIC; -- resultado comparador de ceros
		C1 : in STD_LOGIC; -- resultado comparador de unos
		C2 : in STD_LOGIC; -- resultado comparador de ceros para separador
		BTN : in STD_LOGIC;				-- Boton 3 de la FPGA
		CODIGO : out STD_LOGIC_VECTOR (7 downto 0); -- código morse obtenido
		VALID_DISP : out STD_LOGIC; -- validación del display
		LED_FIN : out STD_LOGIC);		-- bit que enciende el led LD1
end component;

component visualizacion
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada siguiente carácter
		EN : in STD_LOGIC; -- Activación para desplazamiento
		CLK_1ms : in STD_LOGIC; -- Entrada de reloj de refresco
		SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
		AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end component;

signal valor_detect, dur_dato, dur_valid, comp_C0, comp_C1, comp_C2, ctrl_valid, div_clk: std_logic;
signal ctrl_cod: std_logic_vector (7 downto 0);
signal dur_duracion: std_logic_vector (15 downto 0);

begin

-- Interconexiones de módulos

U1 : div_reloj port map (CLK, div_clk);
U2 : detector_flanco port map (div_clk, LIN, valor_detect);
U3 : aut_duracion port map (div_clk, valor_detect, dur_valid, dur_dato, dur_duracion);
U4 : comp_16 port map (dur_duracion, UMBRAL0, comp_C0);
U5 : comp_16 port map (dur_duracion, UMBRAL1, comp_C1);
U6 : comp_16 port map (dur_duracion, UMBRAL2, comp_C2);
U7 : aut_control port map (div_clk, dur_valid, dur_dato, comp_C0, comp_C1, comp_C2, BTN3, ctrl_cod, ctrl_valid, LED1);
U8 : visualizacion port map (ctrl_cod, ctrl_valid, div_clk, SEG7, AN);


end a_receptor;
