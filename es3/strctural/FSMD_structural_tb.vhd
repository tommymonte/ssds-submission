library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMD_structural_tb is
end entity FSMD_structural_tb;

architecture beh of FSMD_structural_tb is

    -- 1. Declare the component to be tested (DUT)
    component FSMD_structural is
        port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            Go        : in  std_logic;
            N_address : out std_logic_vector(9 downto 0);
            data_in   : in  std_logic_vector(15 downto 0);
            Average   : out std_logic_vector (15 downto 0);
            Finish    : out std_logic
        );
    end component FSMD_structural;

    -- Constants
    constant CLK_PERIOD      : time    := 10 ns;
    constant EXPECTED_AVG_VAL: integer := 512;

    -- 2. Signals to connect to the DUT
    signal tb_clk       : std_logic := '0';
    signal tb_rst       : std_logic := '1';
    signal tb_Go        : std_logic := '0';
    signal tb_N_address : std_logic_vector(9 downto 0);
    signal tb_data_in   : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Average   : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Finish    : std_logic := '0';

    -- 3. RAM model
    type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
    signal ram_memory : ram_type;

begin

    -- 4. Instantiate the DUT
    uut: FSMD_structural port map (
        clk       => tb_clk,
        rst       => tb_rst,
        Go        => tb_Go,
        N_address => tb_N_address,
        data_in   => tb_data_in,
        Average   => tb_Average,
        Finish    => tb_Finish
    );

    -- 5. Clock generator
    clk_process: process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_process;

    -- 6. RAM simulation process (with 1-cycle read latency)
    ram_process: process (tb_clk)
    begin
        if rising_edge(tb_clk) then
            tb_data_in <= ram_memory(to_integer(unsigned(tb_N_address)));
        end if;
    end process ram_process;

    -- 7. Stimulus and verification process
    stim_proc: process
    begin
        report "Starting testbench for structural FSMD." severity note;

        -- Initialize RAM
        report "Initializing RAM..." severity note;
        for i in 0 to 1023 loop
            ram_memory(i) <= std_logic_vector(to_unsigned(i + 1, 16));
        end loop;

        -- Reset pulse
        wait for 50 ns;
        tb_rst <= '0';
        wait for 20 ns;

        -- Start the calculation with a 'Go' pulse
        report "Starting calculation with Go signal." severity note;
        tb_Go <= '1';
        wait for CLK_PERIOD;
        tb_Go <= '0';

        -- Wait for the calculation to finish
        wait until tb_Finish = '1';

        -- Wait an additional cycle for the output to stabilize
        wait for CLK_PERIOD;

        -- Print the result
        report "Average calculated: " & integer'image(to_integer(unsigned(tb_Average)));

        -- Check the result
        assert to_integer(unsigned(tb_Average)) = EXPECTED_AVG_VAL
            report "Test Failed! Incorrect average." severity error;

        report "Test Passed! Correct average." severity note;

        -- End of simulation
        wait;

    end process stim_proc;

end architecture beh;