library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dpram is
	generic (
		DPRAM_BITS_WIDTH : natural := 1; -- Ancho de palabra de la memoria medido en bits
		DPRAM_ADDR_BITS : natural := 16 -- Cantidad de bits de address (tamaño de la memoria es 2^ADDRS_BITS
	);
	port (
		rst : in std_logic;
		clk : in std_logic;
		data_wr : in std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0);
		addr_wr : in std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
		ena_wr : in std_logic;
		addr_rd : in std_logic_vector(DPRAM_ADDR_BITS-1 downto 0);
		data_rd : out std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0)
	);
end dpram;


architecture rtl of dpram is
	-- Array para la memoria
	subtype t_word is std_logic_vector(DPRAM_BITS_WIDTH-1 downto 0);
	type t_memory is array(2**DPRAM_ADDR_BITS-1 downto 0) of t_word;
	signal ram : t_memory;
	-- Address casting
	signal rd_pointer : integer range 0 to 2**DPRAM_ADDR_BITS-1;
	signal wr_pointer : integer range 0 to 2**DPRAM_ADDR_BITS-1;
	begin
	-- Address casting
	rd_pointer <= to_integer(unsigned(addr_rd));
	wr_pointer <= to_integer(unsigned(addr_wr));
	-- Write
	process(clk)
		begin
		if clk='1' and clk'event then
			if ena_wr='1' then
				ram(wr_pointer) <= data_wr;
			end if;
		end if;
	end process;
	-- Read
	process(clk)
		begin
		if clk='1' and clk'event then
			data_rd <= ram(rd_pointer);
		end if;
	end process;
end architecture;