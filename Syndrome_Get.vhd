library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Syndrome_Get is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        binary_array  : in  STD_LOGIC_VECTOR(7 downto 0); -- Example array size
        s1            : out STD_LOGIC_VECTOR(7 downto 0); -- Calculated eight bit syndrome 1
        s3            : out STD_LOGIC_VECTOR(7 downto 0)  -- Calculated eight bit syndrome 2
    );
end Syndrome_Get;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity antilog is
port  ( num : in std_logic_vector(7 downto 0);
data_out : out std_logic_vector(7 downto 0));
end entity;


architecture Behavioral of Syndrome_Get is
    signal temp_s1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal temp_s3 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal temp_count   : INTEGER := 0;
    component antilog is
        Port (
            num      : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    signal antilog_out_s1 : STD_LOGIC_VECTOR(7 downto 0);
    signal antilog_out_s3 : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_s1 <= (others => '0');
            temp_s3 <= (others => '0');
            temp_count <= 0;
        elsif rising_edge(clk) then
            temp_s1 <= (others => '0'); -- Reset syndromes for the new binary array
            temp_s3 <= (others => '0');
            temp_count <= 0; -- Reset count for the new binary array
            for i in 0 to binary_array'length - 1 loop
                if binary_array(i) = '1' then
                    temp_count <= temp_count + 1;
                    -- Update s1 and s3 using the antilog results
                    temp_s1 <= temp_s1 xor antilog_out_s1;
                    temp_s3 <= temp_s3 xor antilog_out_s3;
                end if;
            end loop;
        end if;
    end process;

    s1 <= temp_s1;
    s3 <= temp_s3;

    -- Instantiate the antilog component for s1 calculation
    antilog_s1: antilog port map(
        num      => std_logic_vector(to_unsigned(255 - temp_count, 8)),
        data_out => antilog_out_s1
    );

    -- Instantiate the antilog component for s3 calculation
    antilog_s3: antilog port map(
        num      => std_logic_vector(to_unsigned(255 - (3 * temp_count), 8)), 
        data_out => antilog_out_s3
    );

end Behavioral;



architecture antilog_arch of antilog is
    type ROM_type is array (0 to 255) of std_logic_vector(7 downto 0);

    constant ROM : ROM_type := (
         0 => "00000001", 1 => "00000010", 2 => "00000100", 3 => "00001000", 4 => "00010000", 5 => "00100000", 6 => "01000000", 7 => "10000000",
  8 => "00011101", 9 => "00111010", 10 => "01110100", 11 => "11101000", 12 => "11001101", 13 => "10000111", 14 => "00010011", 15 => "00100110",
  16 => "01001100", 17 => "10011000", 18 => "00101101", 19 => "01011010", 20 => "10110100", 21 => "01110101", 22 => "11101010", 23 => "11001001",
  24 => "10001111", 25 => "00000011", 26 => "00000110", 27 => "00001100", 28 => "00011000", 29 => "00110000", 30 => "01100000", 31 => "11000000",
  32 => "10011101", 33 => "00100111", 34 => "01001110", 35 => "10011100", 36 => "00100101", 37 => "01001010", 38 => "10010100", 39 => "00110101",
  40 => "01101010", 41 => "11010100", 42 => "10110111", 43 => "01110111", 44 => "11101110", 45 => "11000001", 46 => "10011111", 47 => "00100011",
  48 => "01000110", 49 => "10001100", 50 => "00000101", 51 => "00001010", 52 => "00010100", 53 => "00101000", 54 => "01010000", 55 => "10100000",
  56 => "01011101", 57 => "10111010", 58 => "01101001", 59 => "11010101", 60 => "10111001", 61 => "01101111", 62 => "11011110", 63 => "10100001",
  64 => "01011111", 65 => "10111110", 66 => "01100001", 67 => "11000010", 68 => "10011001", 69 => "00101111", 70 => "01011110", 71 => "10111100",
  72 => "01100011", 73 => "11000101", 74 => "10001011", 75 => "00001111", 76 => "00011110", 77 => "00111100", 78 => "01111000", 79 => "11110000",
  80 => "11111101", 81 => "11100111", 82 => "11010011", 83 => "10111011", 84 => "01101011", 85 => "11010110", 86 => "10110001", 87 => "01111110",
  88 => "11111110", 89 => "11100001", 90 => "11011111", 91 => "10100011", 92 => "01011011", 93 => "10110110", 94 => "01110011", 95 => "11100100",
  96 => "11011001", 97 => "10101111", 98 => "01001111", 99 => "10010110", 100 => "00110111", 101 => "01101110", 102 => "11011100", 103 => "10100101",
  104 => "01010011", 105 => "10100110", 106 => "01010001", 107 => "10100010", 108 => "01010101", 109 => "10101010", 110 => "01001001", 111 => "10010010",
  112 => "00111001", 113 => "01110010", 114 => "11100100", 115 => "11010101", 116 => "10110111", 117 => "01110011", 118 => "11100110", 119 => "11010001",
  120 => "10111111", 121 => "01100011", 122 => "11000101", 123 => "10010001", 124 => "00111111", 125 => "01111110", 126 => "11111100", 127 => "11100101",
  128 => "11011011", 129 => "10110011", 130 => "01111101", 131 => "11111010", 132 => "11011111", 133 => "10101101", 134 => "01001101", 135 => "10011010",
  136 => "00110101", 137 => "01101010", 138 => "11010100", 139 => "10101001", 140 => "01010110", 141 => "10101100", 142 => "01000101", 143 => "10001010",
  144 => "00001001", 145 => "00010010", 146 => "00100100", 147 => "01001000", 148 => "10010000", 149 => "00111110", 150 => "01111100", 151 => "11111000",
  152 => "11110101", 153 => "11110111", 154 => "11111001", 155 => "11111011", 156 => "11111101", 157 => "11110011", 158 => "11100111", 159 => "11011111",
  160 => "10101101", 161 => "01001011", 162 => "10010110", 163 => "00101101", 164 => "01011010", 165 => "10110100", 166 => "01110001", 167 => "11100010",
  168 => "11010010", 169 => "10110011", 170 => "01111101", 171 => "11111010", 172 => "11111011", 173 => "11111101", 174 => "11101110", 175 => "11011100",
  176 => "10100100", 177 => "01001001", 178 => "10010010", 179 => "00111101", 180 => "01111010", 181 => "11110100", 182 => "11101001", 183 => "11001111",
  184 => "10010111", 185 => "00101001", 186 => "01010010", 187 => "10100100", 188 => "01001000", 189 => "10010000", 190 => "00111110", 191 => "01111100",
  192 => "11111000", 193 => "11110101", 194 => "11101011", 195 => "11001111", 196 => "10011111", 197 => "00100011", 198 => "01000110", 199 => "10001100",
  200 => "00000101", 201 => "00001010", 202 => "00010100", 203 => "00101000", 204 => "01010000", 205 => "10100000", 206 => "01011101", 207 => "10111010",
  208 => "01101001", 209 => "11010101", 210 => "10111001", 211 => "01101111", 212 => "11011110", 213 => "10101101", 214 => "01001101", 215 => "10011010",
  216 => "00110101", 217 => "01101010", 218 => "11010100", 219 => "10101001", 220 => "01010110", 221 => "10101100", 222 => "01000101", 223 => "10001010",
  224 => "00001001", 225 => "00010010", 226 => "00100100", 227 => "01001000", 228 => "10010000", 229 => "00111110", 230 => "01111100", 231 => "11111000",
  232 => "11110101", 233 => "11110111", 234 => "11111001", 235 => "11111011", 236 => "11111101", 237 => "11110011", 238 => "11100111", 239 => "11011111",
  240 => "10101101", 241 => "01001011", 242 => "10010110", 243 => "00101101", 244 => "01011010", 245 => "10110100", 246 => "01110001", 247 => "11100010",
  248 => "11010010", 249 => "10110011", 250 => "01111101", 251 => "11111010", 252 => "11011100", 253 => "10100100", 254 => "01001001", 255 => "10010010"


    );
begin
    data_out <= ROM(to_integer(unsigned(num)));
end architecture;

