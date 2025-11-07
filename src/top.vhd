library ieee;
use ieee.std_logic_1164.all;

entity top is
generic (
    FCLKMHZ  : integer := 50
);
port (
    rst      : in  std_logic;
    clk      : in  std_logic;

    -- Dartboard
    scan_in  : in  std_logic_vector(7 downto 0);
    scan_out : out std_logic_vector(7 downto 0)
);
end entity;

architecture arch of top is
    component sampler is
    generic (
        FCLKMHZ   : integer
    );
    port (
        rst       : in  std_logic;
        clk       : in  std_logic;

        -- Game
        score_num : out std_logic_vector(4 downto 0);
        score_mul : out std_logic_vector(2 downto 0);
        score_en  : out std_logic;

        -- Dartboard
        scan_in   : in  std_logic_vector(7 downto 0);
        scan_out  : out std_logic_vector(7 downto 0)
    );
    end component;

    signal score_num : std_logic_vector(4 downto 0);
    signal score_mul : std_logic_vector(2 downto 0);
    signal score_en  : std_logic;
begin

    ---
    -- Sampler
    sampler_0: sampler
    generic map (
        FCLKMHZ => FCLKMHZ
    )
    port map (
        rst => rst,
        clk => clk,

        -- Game
        score_num => score_num,
        score_mul => score_mul,
        score_en  => score_en,

        -- Dartboard
        scan_in   => scan_in,
        scan_out  => scan_out
    );

end architecture;
