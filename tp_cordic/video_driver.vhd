library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity video_driver is
	generic (
		DPRAM_BITS_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bits
		DPRAM_ADDR_BITS : natural := 16 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS
	);
    port (
		rst: in std_logic;
		clk: in std_logic;
		red_en_o: out std_logic;
		green_en_o: out std_logic;
		blue_en_o: out std_logic;
		pixel_row_i: in std_logic_vector(9 downto 0);
		pixel_col_i: in std_logic_vector(9 downto 0);
		addr_rd : out std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
		data_rd : in std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0)
	);

end video_driver;

architecture Behavioral of video_driver is
	
	signal sig_vram_addr_rd_current, sig_vram_addr_rd_next : std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
	signal sig_pixel_current, sig_pixel_next: std_logic := '0';
	
	begin
	
	process(clk, rst)
	begin
	if(rst='1') then
		sig_vram_addr_rd_current <= "0000000000000000";
		sig_pixel_current <= '0';
    elsif (clk'event and clk='1') then
		sig_vram_addr_rd_current <= sig_vram_addr_rd_next;
		sig_pixel_current <= sig_pixel_next;
    end if;
    end process;

	process(pixel_row_i, pixel_col_i, sig_pixel_current, sig_vram_addr_rd_current, data_rd)
	begin
	sig_vram_addr_rd_next <= sig_vram_addr_rd_current;
	sig_pixel_next <= sig_pixel_current;
		if (to_integer(unsigned(pixel_row_i)) <= 255 and to_integer(unsigned(pixel_col_i)) <= 255) then
			sig_vram_addr_rd_next <= pixel_row_i(7 downto 0) & pixel_col_i(7 downto 0);
			sig_pixel_next <= data_rd(0);
		else
			sig_vram_addr_rd_next <= "0000000000000000";
			sig_pixel_next <= '0';
		end if;
	end process;
	
	addr_rd <= sig_vram_addr_rd_current;
	red_en_o <= sig_pixel_current;
	green_en_o <= sig_pixel_current;
	blue_en_o <= sig_pixel_current;
	
end Behavioral;

