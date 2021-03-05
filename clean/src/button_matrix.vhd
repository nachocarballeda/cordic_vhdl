library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity button_matrix is
Port (
    clk: in std_logic;
    matrix_col : in  std_logic_vector(3 downto 0);
    matrix_row : in  std_logic_vector(3 downto 0);
    reset_button: out std_logic;
    up_x : out  std_logic;
    down_x : out std_logic;
    up_y : out  std_logic;
    down_y : out std_logic;
    up_z : out  std_logic;
    down_z : out std_logic;
    angle_step_up : out  std_logic;
    angle_step_down : out std_logic
    );
end button_matrix;


architecture Behavioral of button_matrix is
    
    signal button_number: natural := 0;
    
begin
    process(clk, matrix_col, matrix_row)
    begin
        button_number <= to_integer(unsigned(matrix_row & matrix_col));
        if (clk'event and clk='1') then
            if(button_number = 246) then --up x
                up_x <= '1';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 245) then--down x
                up_x <= '0';
                down_x <= '1';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 238) then--up y
                up_x <= '0';
                down_x <= '0';
                up_y <= '1';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 237) then--down y
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '1';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 222) then--up z
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '1';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 221) then--down z
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '1';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 243) then--angle step up
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '1';
                angle_step_down <= '0';
                reset_button <= '1';
            elsif(button_number = 235) then--angle step down
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '1';
                reset_button <= '1';
            elsif(button_number = 191) then --reset
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '0';
            else
                up_x <= '0';
                down_x <= '0';
                up_y <= '0';
                down_y <= '0';
                up_z <= '0';
                down_z <= '0';
                angle_step_up <= '0';
                angle_step_down <= '0';
                reset_button <= '1';
            end if;
        end if;
    end process;

end Behavioral;

