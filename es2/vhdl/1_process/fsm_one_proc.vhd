library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_one is
    port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        x      : in  std_logic;
        z      : out std_logic
    );
end entity fsm_one;

architecture behavior of fsm_one is
    type state_type is (IDLE, S0, S1, S01, S10);
    signal c_state: state_type;
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                c_state <= IDLE;
                z <= '0';
            else
                case c_state is
                    when IDLE =>
                        z <= '0';
                        if x = '1' then
                            c_state <= S1;
                        else
                            c_state <= S0;
                        end if;
                    when S0 =>
                        z <= '0';
                        if x = '1' then
                            c_state <= S01;
                        else
                            c_state <= S0;
                        end if;
                    when S1 =>
                        z <= '0';
                        if x = '1' then
                            c_state <= S1;
                        else
                            c_state <= S10;
                        end if;
                    when S01 =>
                        z <= '1';
                        if x = '1' then
                            c_state <= S1;
                        else
                            c_state <= S10;
                        end if;
                    when S10 =>
                        z <= '1';
                        if x = '1' then
                            c_state <= S01;
                        else
                            c_state <= S0;
                        end if;
                    when others =>
                        c_state <= IDLE;
                        z <= '0';
        end case;
        end if;
        end if;
    end process;
end architecture behavior;