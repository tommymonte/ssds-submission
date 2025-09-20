library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSMD_tb is
end entity FSMD_tb;

architecture beh of FSMD_tb is
    
    component FSMD is
        port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            Go        : in  std_logic;
            N_address : out std_logic_vector(9 downto 0);
            data_in   : in  std_logic_vector(15 downto 0);
            WE        : out std_logic;
            Average   : out std_logic_vector(15 downto 0);
            Finish    : out std_logic
        );
    end component FSMD;

    constant CLK_PERIOD      : time    := 10 ns;
    constant EXPECTED_AVG_VAL: integer := 512;


    signal tb_clk       : std_logic := '0';
    signal tb_rst       : std_logic:='1' ; 
    signal tb_Go        : std_logic := '0';
    signal tb_N_address : std_logic_vector(9 downto 0); 
    signal tb_data_in   : std_logic_vector(15 downto 0) := (others => '0'); 
    signal tb_Average   : std_logic_vector(15 downto 0) := (others => '0');
    signal tb_Finish    : std_logic := '0';
    signal tb_WE        : std_logic;

    type ram_type is array (0 to 1023) of std_logic_vector(15 downto 0);
    signal ram_memory : ram_type;
begin


    uut: FSMD port map (
        clk       => tb_clk,
        rst       => tb_rst,
        Go        => tb_Go,
        N_address => tb_N_address,
        data_in   => tb_data_in,
        WE        => tb_WE,
        Average   => tb_Average,
        Finish    => tb_Finish
    );


    clk_process: process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_process;


    ram_process: process (tb_clk)
    begin
        if rising_edge(tb_clk) then
            tb_data_in <= ram_memory(to_integer(unsigned(tb_N_address)));
        end if;
    end process ram_process;
    

    stim_proc: process
    begin
        report "Inizio del testbench per HLSM." severity note;

        for i in 0 to 1023 loop
            ram_memory(i) <= std_logic_vector(to_unsigned(i + 1, 16));
        end loop;
        -- Reset pulse
        wait for 50 ns;
        tb_rst <= '0';
        wait for 20 ns;

        tb_Go <= '1';
        wait for CLK_PERIOD;
        tb_Go <= '0';
        wait until tb_Finish = '1';

        wait for CLK_PERIOD;
        -- Print result
        report "Average calculated: " & integer'image(to_integer(unsigned(tb_Average)));
        -- Check the result
        assert to_integer(unsigned(tb_Average)) = EXPECTED_AVG_VAL
            report "Test Failed! Incorrect average."
            severity error;
        report "Test Passed! Correct average."
            severity note;
        wait;
        
    end process stim_proc;

end architecture beh;