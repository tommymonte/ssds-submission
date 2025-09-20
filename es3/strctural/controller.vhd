library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        rst        : in  std_logic;
        Go         : in  std_logic;
        -- Status from datapath
        ieq        : in  std_logic;
        -- Control signals to datapath
        ld_acc     : out std_logic;
        ld_i       : out std_logic;
        ld_avg     : out std_logic;
        rst_acc    : out std_logic;
        rst_i      : out std_logic;
        rst_avg    : out std_logic;
        finish_set : out std_logic;
        -- External output
        Finish     : out std_logic;
        WE        : out std_logic
    );
end entity controller;

architecture beh of controller is
    type state_type is (IDLE, S1, S2, S3, S4, S5);
    signal c_state, n_state : state_type;

begin
    WE <= '0'; -- No write operation to RAM, only read

    SP : process(clk, rst) begin
        if rising_edge(clk) then
            if rst = '1' then
                c_state <= IDLE;
            else
                c_state <= n_state;
            end if;
        end if;
    end process SP;

    NSL : process(c_state, Go, ieq) begin

        rst_acc <= '0';
        rst_i   <= '0';
        rst_avg <= '0';
        ld_acc  <= '0';
        ld_i    <= '0';
        ld_avg  <= '0';
        Finish  <= '0';
        finish_set <= '0';

        case c_state is
            when IDLE =>
                if Go = '1' then
                    n_state <= S1;
                else
                    n_state <= IDLE;
                end if;
            when S1 =>
                rst_acc <= '1';
                rst_i   <= '1';
                n_state <= S2;
            when S2 =>
                n_state <= S3;
            when S3 =>
                ld_acc <= '1';
                ld_i   <= '1';
                if ieq = '1' then
                    n_state <= S4;
                else
                    n_state <= S2;
                end if;
            when S4 =>
                ld_avg  <= '1';
                n_state <= S5;
            when S5 =>
                Finish     <= '1';
                finish_set <= '1';
                n_state    <= IDLE;
            when others =>
                n_state <= IDLE;
        end case;
    end process NSL;

end architecture beh;