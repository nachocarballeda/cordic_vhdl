-----------------------------------------------
--          Transmit State Machine           --
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmit is
   generic (
	NDBits : natural := 8
   );
   port (
   	CLK : in std_logic;
	RST : in std_logic;
	Tx : out std_logic;
       Din  : in std_logic_vector (NDBits-1 downto 0);
       TxBusy : out std_logic;
       TopTx : in std_logic;
       StartTx : in std_logic
   );
end;

architecture arch of transmit is
   signal Tx_Reg : std_logic_vector (NDBits downto 0);
   type State_Type is (Idle, Load_Tx, Shift_Tx, Stop_Tx);
   signal TxFsm : State_Type;
   signal RegDin : std_logic_vector (NDBits-1 downto 0);
   signal TxBitCnt : natural range 0 to 15;
begin
   TX <= Tx_Reg(0);

   Tx_FSM: process (RST, CLK)
	begin
   		if RST='1' then
      			Tx_Reg <= (others => '1');
			TxBitCnt <= 0;
			TxFSM <= idle;
			TxBusy <= '0';
			RegDin <= (others=>'0');
		elsif rising_edge(CLK) then
			TxBusy <= '1'; -- except when explicitly '0'
			case TxFSM is
				when Idle =>
					if StartTx='1' then
               					-- latch the input data immediately.
						RegDin <= Din;
						TxBusy <= '1';
						TxFSM <= Load_Tx;
					else
						TxBusy <= '0';
					end if;
				when Load_Tx =>
					if TopTx='1' then
						TxFSM <= Shift_Tx;
						TxBitCnt <= (NDBits + 1); -- start + data
						Tx_reg <= RegDin & '0';
					end if;
				when Shift_Tx =>
					if TopTx='1' then
						TxBitCnt <= TxBitCnt - 1;
						Tx_reg <= '1' & Tx_reg (Tx_reg'high downto 1);
	               				if TxBitCnt=1 then
							TxFSM <= Stop_Tx;
						end if;
					end if;
				when Stop_Tx =>
					if TopTx='1' then
						TxFSM <= Idle;
					end if;
				when others =>
					TxFSM <= Idle;
			end case;
		end if;
	end process;
end architecture;
