----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:05:21 11/20/2018 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

entity main is
	Port ( CLK : in STD_LOGIC;
		BTN_START : in STD_LOGIC;
		BTN_STOP : in STD_LOGIC;
		BTN_FIN : in STD_LOGIC;
		SPI_CLK : out STD_LOGIC;
		SPI_DIN : out STD_LOGIC;
		SPI_CS1 : out STD_LOGIC;
		LIN : in STD_LOGIC; -- Línea de entrada de datos
		AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación individual displays
		SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
		LED_FIN : out STD_LOGIC);
end main;

architecture a_main of main is

component GEN_SENAL
	Port ( CLK : in STD_LOGIC;
		BTN0 : in STD_LOGIC;
		BTN1 : in STD_LOGIC;
		SPI_CLK : out STD_LOGIC;
		SPI_DIN : out STD_LOGIC;
		SPI_CS1 : out STD_LOGIC);
end component;

component receptor
	Port ( CLK : in STD_LOGIC; -- reloj de la FPGA
		LIN : in STD_LOGIC; -- Línea de entrada de datos
		BTN3 : in STD_LOGIC;
		AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación individual
		SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
		LED1 : out STD_LOGIC);
end component;

begin

U1 : gen_senal port map
	(CLK => CLK,
	BTN0 => BTN_START,
	BTN1 => BTN_STOP,
	SPI_CLK => SPI_CLK,
	SPI_DIN => SPI_DIN,
	SPI_CS1 => SPI_CS1);

U2 : receptor port map
	(CLK => CLK,
	LIN => LIN,
	BTN3 => BTN_FIN,
	AN => AN,
	SEG7 => SEG7,
	LED1 => LED_FIN);
	
end a_main;