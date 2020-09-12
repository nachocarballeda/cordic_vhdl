library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity write_in_vram is
	generic (
		DPRAM_BITS_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bits
		DPRAM_ADDR_BITS : natural := 16 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS
	);
    port (
		rst: in std_logic;
		clk: in std_logic;
		ena_wr : out std_logic;
		addr_wr : out std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
		data_wr : out std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0)
	);

end write_in_vram;

architecture Behavioral of write_in_vram is
 
 	signal sig_vram_addr_wr_pointer: natural range 0 to 2**DPRAM_ADDR_BITS-1 := 0;
	signal sig_vram_data_wr: std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0) := "0";	
	signal sig_vram_ena_wr: std_logic := '0';

	begin
	
	process(clk, rst)
	begin
	if(rst='1') then
		sig_vram_addr_wr_pointer <= 0;
    elsif (clk'event and clk='1') then
		if (sig_vram_addr_wr_pointer = 65536) then --TODO replace this harcoded value (255*255)..
			sig_vram_addr_wr_pointer <= 0;
		else 
			sig_vram_addr_wr_pointer <= sig_vram_addr_wr_pointer + 1;
		end if;
    end if;
    end process;

	process(sig_vram_addr_wr_pointer)
	begin
		if (sig_vram_addr_wr_pointer = 0) then
			sig_vram_data_wr <= "1";
			sig_vram_ena_wr <= '1';
		else
			sig_vram_data_wr <= "0";
			sig_vram_ena_wr <= '0';
		end if;
	end process;
	
	addr_wr <= std_logic_vector(to_unsigned(sig_vram_addr_wr_pointer, DPRAM_ADDR_BITS));
	ena_wr <= sig_vram_ena_wr;
	data_wr <= sig_vram_data_wr;
	
end Behavioral;