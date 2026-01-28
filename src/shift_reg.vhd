/*
    Template for a generic shift register
*/

-- Load libraries
library ieee;
use ieee.std_logic_1164.all;

-- define generic shift register module
entity shift_reg is
    generic (
        -- shift register width (in bits)
        width: positive := 8
    );

    port (
        serial_in: in std_ulogic; -- serial input
        rst_n, mclk: in std_ulogic; -- reset and clock

        b: out std_ulogic_vector(width-1 downto 0); -- parallel output
        serial_out: out std_ulogic -- serial output
    );
end entity shift_reg;

architecture rtl of shift_reg is
    -- define external component (D flip-flop)
    component dff is
        port (
            rst_n, mclk: in std_ulogic;
            din: in std_ulogic;
            dout: out std_ulogic
        );
    end component;

    signal c: std_ulogic_vector(width downto 0);
begin
    -- map c to b, serial_in, and serial_out
    b <= c(width-1 downto 0);
    c(width) <= serial_in;
    serial_out <= c(0);

    -- chain flip-flops together
    inner_chain: for i in 0 to (width - 1) generate
        ff: dff
            -- map 'rst_n' and 'mclk' to all flip-flops,
            -- then chain the flip-flops low-to-high,
            -- so that c(0) corresponds to the first
            -- flip-flop output, and c(width) corresponds
            -- to the last flip-flop input
            port map (
                rst_n => rst_n,
                mclk => mclk,
                din => c(i+1),
                dout => c(i)
            );
    end generate;
end architecture rtl;
