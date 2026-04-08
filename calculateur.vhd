library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculateur is
    port (
        clk      : in  std_logic;
        reset_n  : in  std_logic;
        
        -- Interface de commande (venant du processeur)
        op_sel   : in  std_logic_vector(1 downto 0);
        
        -- Données d'entrée (venant du module capteurs_sol)
        data_A   : in  std_logic_vector(7 downto 0);
        data_B   : in  std_logic_vector(7 downto 0);
        
        -- Résultat (vers le processeur, 9 bits pour éviter l'overflow)
        result   : out std_logic_vector(8 downto 0)
    );
end calculateur;

architecture rtl of calculateur is
begin
    process(clk, reset_n)
        variable temp_A : unsigned(8 downto 0);
        variable temp_B : unsigned(8 downto 0);
    begin
        if reset_n = '0' then
            result <= (others => '0');
            
        elsif rising_edge(clk) then
            -- Extension à 9 bits pour les calculs (prévention overflow)
            temp_A := resize(unsigned(data_A), 9);
            temp_B := resize(unsigned(data_B), 9);

            case op_sel is
                when "00" => 
                    -- Addition
                    result <= std_logic_vector(temp_A + temp_B);
                    
                when "01" => 
                    -- Soustraction (Saturée à 0 si B > A pour éviter un underflow)
                    if temp_A > temp_B then
                        result <= std_logic_vector(temp_A - temp_B);
                    else
                        result <= (others => '0');
                    end if;
                    
                when "10" => 
                    -- Amplification numérique (Gain = 2, décalage à gauche)
                    -- Appliqué uniquement sur data_A pour l'exemple
                    result <= std_logic_vector(shift_left(temp_A, 1));
                    
                when "11" => 
                    -- Atténuation numérique (Gain = 0.5, décalage à droite)
                    result <= std_logic_vector(shift_right(temp_A, 1));
                    
                when others =>
                    result <= (others => '0');
            end case;
        end if;
    end process;
end rtl;