/*
    Implementation of an 8-bit shift register
*/

-- Load libraries
library ieee;
use ieee.std_logic_1164.all;

-- define 8-bit shift register module
entity shift32 is
    generic (
        s_width: positive := 32
    );

    port (
        serial_in: in std_ulogic; -- serial input
        rst_n, mclk: in std_ulogic; -- reset and clock

        b: out std_ulogic_vector(s_width - 1 downto 0); -- parallel output
        serial_out: out std_ulogic -- serial output
    );
end entity shift32;

architecture rtl of shift32 is
    component shift_reg is
        generic (
            width: positive := s_width
        );

        port (
            serial_in: in std_ulogic;
            rst_n, mclk: in std_ulogic;
            b: out std_ulogic_vector(s_width - 1 downto 0);
            serial_out: out std_ulogic
        );
    end component;
begin
    sr: shift_reg
        port map (
            serial_in => serial_in,
            rst_n => rst_n,
            mclk => mclk,
            b => b,
            serial_out => serial_out
        );
end architecture rtl;
