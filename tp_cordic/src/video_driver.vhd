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

	signal sig_rd_address : natural := 0;

	begin

	process(clk, rst)
	begin
		if(rst='1') then 
			sig_rd_address <= 0;
		elsif (clk'event and clk='1') then
			sig_rd_address <= sig_rd_address + 1;
			if(sig_rd_address > 65535) then  -- 256*256 - 1
				sig_rd_address <= 0;
			end if;
			if (to_integer(unsigned(pixel_row_i)) < 255 and to_integer(unsigned(pixel_col_i)) < 255) then
				red_en_o <= '1';
				green_en_o <= '1';
				blue_en_o <= '1';
			else
				red_en_o <= '0';
				green_en_o <= '0';
				blue_en_o <= '0';
			end if;
		end if;
	end process;
	
	addr_rd <= std_logic_vector(to_unsigned(sig_rd_address, DPRAM_ADDR_BITS));
	
end Behavioral;

