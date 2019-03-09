library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Mux 4 a 1
entity UD is
    Port ( 	Reg_Rs_ID: in  STD_LOGIC_VECTOR (4 downto 0); --registros Rs y Rt en la etapa ID
		   Reg_Rt_ID	: in  STD_LOGIC_VECTOR (4 downto 0);
			MemRead_EX	: in std_logic; -- informaci贸n sobre la instrucci贸n en EX (destino, si lee de memoria y si escribe en registro)
			RegWrite_EX	: in std_logic;
			RW_EX				: in  STD_LOGIC_VECTOR (4 downto 0);
			RegWrite_Mem	: in std_logic;-- informacion sobre la instruccion en Mem (destino y si escribe en registro)
			RW_Mem			: in  STD_LOGIC_VECTOR (4 downto 0);
			IR_op_code	: in  STD_LOGIC_VECTOR (5 downto 0); -- c贸digo de operaci贸n de la instrucci贸n en IEEE
            		PCSrc			: in std_logic; -- 1 cuando se produce un salto 0 en caso contrario
			FP_add_EX	: in std_logic; -- Indica si la instrucci贸n en EX es un ADDFP
			FP_done		: in std_logic; -- Informa cuando la operaci贸n de suma en FP ha terminado
			Kill_IF		: out  STD_LOGIC; -- Indica que la instrucci贸n en IF no debe ejecutarse (fallo en la predicci贸n de salto tomado)
			Parar_ID		: out  STD_LOGIC; -- Indica que las etapas ID y previas deben parar
			Parar_EX		: out  STD_LOGIC); -- Indica que las etapas EX y previas deben parar
end UD;
Architecture Behavioral of UD is
signal ID_parado: std_logic;
begin
	-- AHora mismo no hace nada. Hay que dise馻r la l骻ica que genera estas se馻les.
	-- Adem醩 hay que conectar estas se馻les con los elementos adecuados para que las 髍denes que indican se realicen
	Parar_EX <= '1' when FP_add_EX = '1' and FP_done = '0'
		else '0' when FP_done = '1'
		else '0';
	ID_parado <= '0' when IR_op_code = "000000"
		else '1' when MemRead_EX = '1' and (Reg_Rs_ID = RW_EX or Reg_Rt_ID = RW_EX)
		else '1' when IR_op_code = "000100" and ((RegWrite_Mem = '1' and (Reg_Rs_ID = RW_MEM or Reg_Rt_ID = RW_MEM)) or (RegWrite_EX = '1' and (Reg_Rt_ID = RW_EX or Reg_Rs_ID = RW_EX)))
		else '0';
	Parar_ID <= ID_parado;
	Kill_IF <= '1' when PCSrc = '1' and IR_op_code = "000100" and ID_parado = '0' --Salto cuando BRANCH Y Z SON 1 Y LA OPERACION ES BEQ
	else '0';


end Behavioral;
