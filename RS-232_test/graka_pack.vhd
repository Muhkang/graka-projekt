-- Christoph Paa

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package graka_pack is

--###########################################################################
--constants
constant c_COM_LENGTH : integer range 0 to 16 := 8;

--###########################################################################
--types
type t_rx_com is (rec_pic, end_pic, check_com, filter_move_hist, unidentified);
type t_tx_com is (board_ack, end_of_block, unidentified);
type t_command_array is ARRAY(0 to 3) of std_logic_vector(c_COM_LENGTH-1 downto 0);
type t_rec_buff_rg is ARRAY(0 to 255) of std_logic_vector(15 downto 0);
type t_rec_buff_b is ARRAY(0 to 255) of std_logic_vector(7 downto 0);

type t_filter_set is record
		move_hist : signed(7 downto 0);
end record;


--###########################################################################
--constants
constant c_rx_com_arr : t_command_array := (x"02", x"03",x"05", x"11");
constant c_tx_com_arr : t_command_array := (x"06", x"17",x"00", x"00");

constant c_filter_set_empty : t_filter_set := (
	move_hist => x"64"
);


--###########################################################################
--functions
function get_tx_command(com_in : t_tx_com) return STD_LOGIC_VECTOR;

function get_rx_command(com_in : STD_LOGIC_VECTOR(c_COM_LENGTH-1 downto 0)) return t_rx_com;

function capped_add(sum1 : unsigned(7 downto 0); sum2 : signed(7 downto 0)) return unsigned;

end package graka_pack;

package body graka_pack is

function capped_add(sum1 : unsigned(7 downto 0); sum2 : signed(7 downto 0)) return unsigned is
	--adds / subtracts sum2 from unsigned sum1, returns result in 0...255 range.
	variable erg : signed(8 downto 0) := (others => '0');
	begin
		erg := signed('0' & sum1) + sum2;
		if erg > 255 then
			return to_unsigned(255,8);
		elsif erg < 0 then
			return to_unsigned(0,8);
		else
			return unsigned(erg(7 downto 0));
		end if;
end function capped_add;
		
function get_tx_command(com_in : t_tx_com) return STD_LOGIC_VECTOR is
	begin
		return c_tx_com_arr(t_tx_com'POS(com_in));
end function get_tx_command;

function get_rx_command(com_in : STD_LOGIC_VECTOR(c_COM_LENGTH-1 downto 0)) return t_rx_com is
	begin
		case com_in is
			when c_rx_com_arr(0) =>
				return t_rx_com'VAL(0);
			when c_rx_com_arr(1) =>
				return t_rx_com'VAL(1);
			when c_rx_com_arr(2) =>
				return t_rx_com'VAL(2);
			when c_rx_com_arr(3) =>
				return t_rx_com'VAL(3);
			when others =>
				return t_rx_com'right;
		end case;
end function get_rx_command;
				


end package body graka_pack;