library ieee;
use ieee.std_logic_1164.all;

entity FSMD_structural is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        Go        : in  std_logic;
        -- RAM interface
        N_address : out std_logic_vector(9 downto 0);
        data_in   : in  std_logic_vector(15 downto 0);
        -- Output
        Average   : out std_logic_vector (15 downto 0);
        Finish    : out std_logic
    );
end entity FSMD_structural;

architecture struct of FSMD_structural is

    -- Component declarations
    component controller is
        port(
            clk        : in  std_logic;
            rst        : in  std_logic;
            Go         : in  std_logic;
            ieq        : in  std_logic;
            ld_acc     : out std_logic;
            ld_i       : out std_logic;
            ld_avg     : out std_logic;
            rst_acc    : out std_logic;
            rst_i      : out std_logic;
            rst_avg    : out std_logic;
            finish_set : out std_logic;
            Finish     : out std_logic
        );
    end component;

    component datapath is
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            data_in     : in  std_logic_vector(15 downto 0);
            ld_acc      : in  std_logic;
            ld_i        : in  std_logic;
            ld_avg      : in  std_logic;
            rst_acc     : in  std_logic;
            rst_i       : in  std_logic;
            rst_avg     : in  std_logic;
            finish_set  : in  std_logic;
            ieq         : out std_logic;
            N_address   : out std_logic_vector(9 downto 0);
            Average     : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal signals for connecting controller and datapath
    signal s_ieq        : std_logic;
    signal s_ld_acc     : std_logic;
    signal s_ld_i       : std_logic;
    signal s_ld_avg     : std_logic;
    signal s_rst_acc    : std_logic;
    signal s_rst_i      : std_logic;
    signal s_rst_avg    : std_logic;
    signal s_finish_set : std_logic;

begin
    -- Instantiate controller
    C1: controller port map(
        clk        => clk,
        rst        => rst,
        Go         => Go,
        ieq        => s_ieq,
        ld_acc     => s_ld_acc,
        ld_i       => s_ld_i,
        ld_avg     => s_ld_avg,
        rst_acc    => s_rst_acc,
        rst_i      => s_rst_i,
        rst_avg    => s_rst_avg,
        finish_set => s_finish_set,
        Finish     => Finish
    );

    -- Instantiate datapath
    D1: datapath port map(
        clk         => clk,
        rst         => rst,
        data_in     => data_in,
        ld_acc      => s_ld_acc,
        ld_i        => s_ld_i,
        ld_avg      => s_ld_avg,
        rst_acc     => s_rst_acc,
        rst_i       => s_rst_i,
        rst_avg     => s_rst_avg,
        finish_set  => s_finish_set,
        ieq         => s_ieq,
        N_address   => N_address,
        Average     => Average
    );

end architecture struct;