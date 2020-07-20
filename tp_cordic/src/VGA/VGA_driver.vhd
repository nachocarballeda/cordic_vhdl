library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity VGA_driver is
	port(
		clk : in std_logic;
		input0_VGA, input1_VGA, input2_VGA : in std_logic_vector(3 downto 0);
		hs_bloque, vs_bloque : out std_logic;
		red_out_bloque : out std_logic_vector(2 downto 0);
		grn_out_bloque : out std_logic_vector(2 downto 0);
		blu_out_bloque : out std_logic_vector(1 downto 0)
		);
end VGA_driver;

architecture VGA_driver_arq of VGA_driver is
---Prototipos de las funciones que uso en esta entity---
	component mux_ROMtoVGA is
		port(
			char0, char1, char2, char3, char4, char5: in std_logic_vector(3 downto 0);
			sel: in std_logic_vector(2 downto 0);
			char_adress : out std_logic_vector(5 downto 0)
			);
	end component;
	component driver is
		port(
			pixel_x_i: in std_logic_vector(9 downto 0);
			pixel_y_i: in std_logic_vector(9 downto 0);
			font_col_o: out std_logic_vector(2 downto 0);
			font_row_o: out std_logic_vector(2 downto 0);
			sel_o: out std_logic_vector(2 downto 0)
			);
	end component;
	component vga_ctrl is
		port(
			mclk, red_i, grn_i, blu_i: in std_logic;
			hs, vs: out std_logic;
			red_o: out std_logic_vector(2 downto 0);
			grn_o: out std_logic_vector(2 downto 0);
			blu_o: out std_logic_vector(1 downto 0);
			pixel_row, pixel_col: out std_logic_vector(9 downto 0)
			);
	end component;	
	component Char_ROM is
	generic(
			N: integer:= 6;
			M: integer:= 3;
			W: integer:= 8
			);
		port(
			char_address: in std_logic_vector(5 downto 0);
			font_row, font_col: in std_logic_vector(M-1 downto 0);
			rom_out: out std_logic
			);
	end component;
---------------------------------------------------------

--Variables auxiliares para pasar datos a las funciones--
	--Carateres estaticos
	signal charComa_aux: std_logic_vector(3 downto 0):="1010";
	signal charV_aux: std_logic_vector(3 downto 0):="1011";
	signal char5_aux: std_logic_vector(3 downto 0):="1100";
	--procesamiento address
	signal aux_sel: std_logic_vector(2 downto 0);
	signal aux_char_adress: std_logic_vector(5 downto 0);
	--impresion caracter 
	signal aux_pixel_x_i: std_logic_vector(9 downto 0);
	signal aux_pixel_y_i: std_logic_vector(9 downto 0);
	signal aux_font_col_o: std_logic_vector(2 downto 0);
	signal aux_font_row_o: std_logic_vector(2 downto 0);
	signal aux_rom_out: std_logic;
---------------------------------------------------------

-----------------Comienzo arquitectura--------------------
begin
---Instancias de las funciones utilizadas en la entity---
	mux_mod: mux_ROMtoVGA
	port map(
			char0 => input0_VGA,
			char1 => input1_VGA,
			char2 => input2_VGA,
			char3 => charComa_aux,
			char4 => charV_aux,
			char5 => char5_aux,
			sel => aux_sel,
			char_adress => aux_char_adress
			);
	driver_mod: driver
	port map(
			pixel_x_i => aux_pixel_x_i,
			pixel_y_i => aux_pixel_y_i,
			font_col_o => aux_font_col_o,
			font_row_o => aux_font_row_o,
			sel_o => aux_sel
			);
	Char_ROM_mod: Char_ROM
	port map(
			char_address => aux_char_adress,
			font_row => aux_font_row_o,
			font_col => aux_font_col_o,
			rom_out =>  aux_rom_out
			);
	vga_ctrl_mod: vga_ctrl
	port map(
			mclk => clk,
			red_i => aux_rom_out,
			grn_i => aux_rom_out,
			blu_i => '1',
			hs => hs_bloque,
			vs => vs_bloque,
			red_o => red_out_bloque, 
			grn_o => grn_out_bloque, 
			blu_o => blu_out_bloque, 
			pixel_row => aux_pixel_y_i,
			pixel_col => aux_pixel_x_i
			);
---------------------------------------------------------		
end VGA_driver_arq;
---------------------------------------------------------

