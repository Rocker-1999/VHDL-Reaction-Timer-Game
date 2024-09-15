library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity ReactionTimerProject is -- Defining inputs
    port(clk, Key0, Key1              : in std_logic; -- Clock and Button inputs
			hex0, hex1, hex2, hex3, hex4 : out std_logic_vector(7 downto 0); -- Seven Segment Displays
			LED                          : out std_logic_vector(9 downto 0)); -- LEDs
end ReactionTimerProject;

architecture behavioral of ReactionTimerProject is
	type state_type is (PressStart, Game, Result); -- Defining states
	signal current_state, next_state : state_type; -- State control signals

	-- Setting all values for HEX displays
	constant P     : std_logic_vector(6 downto 0) := "0001100";
	constant R     : std_logic_vector(6 downto 0) := "0101111";
	constant E     : std_logic_vector(6 downto 0) := "0000110";
	constant S     : std_logic_vector(6 downto 0) := "0010010";
	constant T     : std_logic_vector(6 downto 0) := "0000111";
	constant A     : std_logic_vector(6 downto 0) := "0001000";
	constant BLANK : std_logic_vector(6 downto 0) := (others => '1');
	constant ZERO  : std_logic_vector(6 downto 0) := "1000000";
	constant ONE   : std_logic_vector(6 downto 0) := "1111001";
	constant TWO   : std_logic_vector(6 downto 0) := "0100100";
	constant THREE : std_logic_vector(6 downto 0) := "0110000";
	constant FOUR  : std_logic_vector(6 downto 0) := "0011001";
	constant FIVE  : std_logic_vector(6 downto 0) := "0010010";
	constant SIX   : std_logic_vector(6 downto 0) := "0000010";
	constant SEVEN : std_logic_vector(6 downto 0) := "1111000";
	constant EIGHT : std_logic_vector(6 downto 0) := "0000000";
	constant NINE  : std_logic_vector(6 downto 0) := "0011000";
	
	-- Main game signals
	signal count, game_timer, result_timer, ms_timer, random_time : integer := 0; -- Game timers
	constant max_count : integer := 50000; -- 1 ms in clock cycles (50 kHz=1 ms)
	signal display_press, timer_active : std_logic := '0';

	-- Function that converts integers to HEX displays
	function int_to_display(val: integer) return std_logic_vector is
	variable result : std_logic_vector(6 downto 0);
	begin
		case val is
			when 0 => result := ZERO;
			when 1 => result := ONE;
			when 2 => result := TWO;
			when 3 => result := THREE;
			when 4 => result := FOUR;
			when 5 => result := FIVE;
			when 6 => result := SIX;
			when 7 => result := SEVEN;
			when 8 => result := EIGHT;
			when 9 => result := NINE;
			when others => result := BLANK;
	end case;
	return result;
	end function;

begin
	-- Main game logic
	process(clk)
	begin
		if rising_edge(clk) then
			random_time <= random_time + 1; -- Random timer increments every clock cycle
			if random_time >= 400000000 then 
				random_time <= 0; -- Sets back to 0 every 400 mil. clock cycles (8 seconds)
			end if;
			if timer_active = '1' then
				if count < max_count then
					count <= count + 1; -- Increments count until max_count is reached
				else
					count <= 0;
					ms_timer <= ms_timer + 1; -- Increments ms_timer every millisecond
				end if;
			end if;

			--State machine with game logic per state
			case current_state is
				when PressStart =>
					if count >= max_count * 1000 then
						count <= 0;
						display_press <= not display_press; -- Toggle displays every second
					else
						count <= count + 1;
					end if;
					if Key0 = '0' then
						next_state <= Game; -- Transition to Game state on Key0 press
					else
						next_state <= PressStart;
					end if;
				when Game =>
					if Key1 = '0' and timer_active = '1' then
						next_state <= Result; -- Transition to Result state on Key1 press when LEDs are active
					elsif game_timer >= random_time then 
						LED <= (others => '1'); -- Light up LEDs when game_timer is same as random_time
						timer_active <= '1'; -- Start reaction timing
					else
						game_timer <= game_timer + 1; -- Increments game_timer
					end if;
				when Result =>
					LED <= (others => '0'); -- Turns off LEDs in Result state
					timer_active <= '0';
						if result_timer >= 7 * max_count * 1000 then -- Reset all values below after 7 seconds
							next_state <= PressStart;
							display_press <= '1';
							game_timer <= 0;
							result_timer <= 0;
							ms_timer <= 0;
							random_time <= 0;
						else
							result_timer <= result_timer + 1; -- Increment result_timer
						end if;
			end case;
			current_state <= next_state; -- Update current state to next state
		end if;
	end process;

	-- Display processing per state
	process(current_state, display_press)
	begin
		case current_state is
			when PressStart =>
				if display_press = '0' then
					hex4 <= "1" & P;
					hex3 <= "1" & R;
					hex2 <= "1" & E;
					hex1 <= "1" & S;
					hex0 <= "1" & S;
				else
					hex4 <= "1" & S;
					hex3 <= "1" & T;
					hex2 <= "1" & A;
					hex1 <= "1" & R;
					hex0 <= "1" & T;
				end if;
			when Game =>
				if timer_active = '0' then
					hex4 <= "1" & BLANK;
					hex3 <= "1" & BLANK;
					hex2 <= "1" & BLANK;
					hex1 <= "1" & BLANK;
					hex0 <= "1" & BLANK;
				else
					hex4 <= "1" & BLANK;
					hex3 <= "0" & int_to_display(ms_timer / 1000 mod 10);
					hex2 <= "1" & int_to_display(ms_timer / 100 mod 10);
					hex1 <= "1" & int_to_display(ms_timer / 10 mod 10);
					hex0 <= "1" & int_to_display(ms_timer mod 10);
				end if;
            when Result =>
					hex4 <= "1" & BLANK;
					hex3 <= "0" & int_to_display(ms_timer / 1000 mod 10);
					hex2 <= "1" & int_to_display(ms_timer / 100 mod 10);
					hex1 <= "1" & int_to_display(ms_timer / 10 mod 10);
					hex0 <= "1" & int_to_display(ms_timer mod 10);
		end case;
	end process;
end behavioral;