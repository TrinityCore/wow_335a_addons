local L = AceLibrary("AceLocale-2.2"):new("XLootMonitor")

L:RegisterTranslations("esES", function()
	return {
		catGrowth = "Crecimiento de Filas",
		catLoot = "Botín",
		catPosSelf = "Punto de anclaje...",
		catPosTarget = "En...",
		catPosOffset = "Offset de la ventana...",
		catModules = "Módulos",
		
		moduleHistory = "Historial de Botín",
		moduleActive = "Activo",
		
		historyTime = "Ver por fecha",
		historyPlayer = "Ver por jugador",
		["View by item"] = "Ver por objeto",
		historyClear = "Borrar el historial actual",
		historyEmpty = "No hay historial a mostrar",
		historyTrunc = "Anchura máxima de objeto",
		historyMoney = "Dinero saqueado",
		["Export history"] = "Exportar historial",
		["No export handlers found"] = "No se han encontrado xxx a exportar",
		["Simple XML copy-export"] = "Simple copiar-exportar XML",
		["Copy-Paste Pipe Separated List"] = "Copiar-Pegar listas separadas",
		["Press Control-C to copy the log"] = "Pulsa Control+C para copiar el registro",
		
		["Display Options"] = "Opciones de Visualización",
		
		optStacks = "Lotes/Anclas",
		optLockAll = "Bloquear todas las ventanas",
		optPositioning = "Posicionamiento",
		optMonitor = "XLoot Monitor",
		optAnchor = "Mostrar Ancla",
		optPosVert = "Verticalmente",
		optPosHoriz = "Horizontalmente",
		optTimeout = "Temporizador",
		optDirection = "Dirección",
		optThreshold = "Límite de Lote",
		optQualThreshold = "Límite de Calidad",
		optSelfQualThreshold = "Límite de calidad propio",
		optUp = "Arriba",
		optDown = "Abajo",
		optMoney = "Mostrar las monedas saqueadas",
		["Show countdown text"] = "Muestra un texto con la cuenta atrás",
		["Show totals of your items"] = "Mostrar la cantidad total de tus objetos",
		["Show small text beside the item indicating how much time remains"] = "Muestra un pequeño texto al lado del objeto indicando cuánto tiempo queda",
		["Trim item names to..."] = "Ajustar los nombres de objeto a...",
		["Length in characters to trim item names to"] = "Longitud en caracteres a los que ajustar los nombres de objeto",
		["Show winning group loot"] = "Mostrar el botín ganado por el grupo",
		["Show group roll choices"] = "Mostar las opciones de tiradas de dados del grupo",
		
		descStacks = "Establece las opciones para cada lote individual, como la visibilidad del ancla o el temporizador.",
		descPositioning = "Posición y pegado de las filas en el lote",
		descMonitor = "Configuración del accesorio XLootMonitor",
		descAnchor = "Muestra el ancla para este lote",
		descPosVert = "Desplaza la fila verticalmente desde el punto que elijas para anclarlo en una cantidad específica",
		descPosHoriz = "Desplaza la fila horizontalmente desde el punto que elijas para anclarlo en una cantidad específica",
		descTimeout = "El tiempo a transcurrir hasta que la fila se desvanezca. |cFFFF5522Si estableces esto a 0 desactivarás el desvanecimiento por completo|r",
		descDirection = "Dirección hacia donde crecen lso lotes",
		descThreshold = "Cantidad máxima de filas mostradas en todo momento",
		descQualThreshold = "La calidad mínima del botín del resto de gente que será mostrada por el monitor",
		descSelfQualThreshold = "La calidad mínima de tu propio botín que será mostrada por el monitor",
		descMoney = "Mostrar tu parte de las monedas saqueadas cuando estás en un grupo |cFFFF0000Todavía NO incluye las monedas cuando estás solo.|r",
		
		optPos = {
			TOPLEFT = "Esquina Superior Izquierda",
			TOP = "Arriba",
			TOPRIGHT = "Esquina Superior Derecha",
			RIGHT = "Derecha",
			BOTTOMRIGHT = "Esquina Inferior Derecha",
			BOTTOM = "Abajo",
			BOTTOMLEFT = "Esquina Inferior Izquierda",
			LEFT = "Izquierda",
		},
		
		linkErrorLength = "Al enlazar se crearía un mensaje demasiado largo. Envía o borra el mensaje actual y prueba otra vez.",
		
		playerself = "Tú", 
	}
end)

