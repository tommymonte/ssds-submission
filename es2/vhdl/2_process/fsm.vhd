library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        x      : in  std_logic;
        z      : out std_logic
    );
end entity fsm;

architecture behavior of fsm is

    type state_type is (IDLE, S0, S1, S01, S10);
    signal c_state, n_state : state_type;
begin

first_process : process(clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            c_state <= IDLE;
        else
            c_state <= n_state;
        end if;
    end if;
end process first_process;
second_process : process(c_state, x)
begin
    case c_state is
        when IDLE =>
            z <= '0';
            if x = '1' then
                n_state <= S1;
            else
                n_state <= S0;
            end if;
        when S0 =>
            z <= '0';
            if x = '1' then
                n_state <= S01;
            else
                n_state <= S0;
            end if;
        when S1 =>
            z <= '0';
            if x = '1' then
                n_state <= S1;
            else
                n_state <= S10;
            end if;
        when S01 =>
            z <= '1';
            if x = '1' then
                n_state <= S1;
            else
                n_state <= S10;
            end if;
        when S10 =>
            z <= '1';
            if x = '1' then
                n_state <= S01;
            else
                n_state <= S0;
            end if;
        when others =>
            n_state <= IDLE;
            z <= '0';
    end case;
end process second_process;

end architecture behavior;