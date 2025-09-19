library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end entity fsm_tb;

architecture tb of fsm_tb is
    component fsm_one is
        port(
            clk : in  std_logic;
            rst : in  std_logic;
            x   : in  std_logic;
            z   : out std_logic
        );
    end component;

    signal s_clk : std_logic := '0';
    signal s_rst : std_logic;
    signal s_x   : std_logic;
    signal s_z   : std_logic;

    constant CLK_PERIOD : time := 5 ns;

begin
    uut : fsm_one
        port map(
            clk => s_clk,
            rst => s_rst,
            x   => s_x,
            z   => s_z
        );

    clk_process : process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2;
        s_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stimulus_process : process
    begin
        s_rst <= '1';
        s_x   <= '0';
        wait for 4 ns;
        s_rst <= '0';

        s_x <= '0'; wait for CLK_PERIOD;
        s_x <= '1'; wait for CLK_PERIOD;
        s_x <= '0'; wait for CLK_PERIOD;
        s_x <= '0'; wait for CLK_PERIOD;
        s_x <= '1'; wait for CLK_PERIOD;
        s_x <= '1'; wait for CLK_PERIOD;
        s_x <= '0'; wait for CLK_PERIOD;
        s_x <= '0'; wait for CLK_PERIOD;

        report "Testbench completato.";
        wait;
    end process;

end architecture tb;