
display.setDefault("background", 0.08, 0.09, 0.12)

-------------------------------------------------
-- TITULO
-------------------------------------------------
local titulo = display.newText({
    text = "Calculadora de IMC",
    x = display.contentCenterX,
    y = 50,
    font = native.systemFontBold,
    fontSize = 28
})
titulo:setFillColor(0.9,0.9,0.9)

-------------------------------------------------
-- CAMPOS DE ENTRADA
-------------------------------------------------
local peso = native.newTextField(display.contentCenterX, 110, 220, 40)
peso.placeholder = "Peso (kg)"

local altura = native.newTextField(display.contentCenterX, 170, 220, 40)
altura.placeholder = "Altura (m)"

-------------------------------------------------
-- PANEL DEL MEDIDOR
-------------------------------------------------
local panel = display.newRoundedRect(
    display.contentCenterX,
    370,
    340,
    340,
    20
)
panel:setFillColor(0.12,0.13,0.16)
panel.strokeWidth = 2
panel:setStrokeColor(0.25,0.25,0.3)

-------------------------------------------------
-- MEDIDOR CIRCULAR
-------------------------------------------------
local centroX = display.contentCenterX
local centroY = 370
local radio = 120

local medidorGrupo = display.newGroup()
local segmentos = 60

for i = 0, segmentos-1 do

    local angulo1 = math.rad(i * 360/segmentos)
    local angulo2 = math.rad((i+1) * 360/segmentos)

    local x1 = centroX + radio * math.cos(angulo1)
    local y1 = centroY + radio * math.sin(angulo1)

    local x2 = centroX + radio * math.cos(angulo2)
    local y2 = centroY + radio * math.sin(angulo2)

    local linea = display.newLine(x1,y1,x2,y2)
    linea.strokeWidth = 10
    linea:setStrokeColor(0.3,0.3,0.35)

    medidorGrupo:insert(linea)

end

-------------------------------------------------
-- AGUJA DEL MEDIDOR
-------------------------------------------------
local aguja = display.newLine(
    centroX,
    centroY,
    centroX,
    centroY - radio
)
aguja.strokeWidth = 6
aguja:setStrokeColor(1,1,1)

-- centro decorativo
local centro = display.newCircle(centroX, centroY, 8)
centro:setFillColor(1,1,1)

-------------------------------------------------
-- TEXTO IMC DENTRO DEL CIRCULO
-------------------------------------------------
local textoIMC = display.newText({
    text = "--",
    x = centroX,
    y = centroY,
    font = native.systemFontBold,
    fontSize = 36
})
textoIMC:setFillColor(1,1,1)

-------------------------------------------------
-- CATEGORIA
-------------------------------------------------
local categoriaTexto = display.newText({
    text = "Categoría: --",
    x = display.contentCenterX,
    y = 520,
    font = native.systemFontBold,
    fontSize = 22
})
categoriaTexto:setFillColor(0.8,0.8,0.8)

-------------------------------------------------
-- FUNCION MOVER AGUJA
-------------------------------------------------
local function moverAguja(imc)

    local minIMC = 10
    local maxIMC = 40

    if imc < minIMC then imc = minIMC end
    if imc > maxIMC then imc = maxIMC end

    local porcentaje = (imc - minIMC) / (maxIMC - minIMC)
    local angulo = porcentaje * 360

    aguja.rotation = angulo

end

-------------------------------------------------
-- FUNCION CALCULAR IMC
-------------------------------------------------
local function calcularIMC()

    local p = tonumber(peso.text)
    local h = tonumber(altura.text)

    if not p or not h then
        textoIMC.text = "--"
        categoriaTexto.text = "Ingresa valores válidos"
        return
    end

    local imc = p / (h*h)
    imc = math.floor(imc * 10) / 10

    textoIMC.text = imc

    moverAguja(imc)

    -------------------------------------------------
    -- CLASIFICACION
    -------------------------------------------------
    if imc < 18.5 then

        categoriaTexto.text = "Bajo peso"
        categoriaTexto:setFillColor(1,0.7,0.2)
        aguja:setStrokeColor(1,0.7,0.2)

    elseif imc < 25 then

        categoriaTexto.text = "Saludable"
        categoriaTexto:setFillColor(0.2,0.8,0.4)
        aguja:setStrokeColor(0.2,0.8,0.4)

    elseif imc < 30 then

        categoriaTexto.text = "Advertencia"
        categoriaTexto:setFillColor(1,0.5,0.2)
        aguja:setStrokeColor(1,0.5,0.2)

    else

        categoriaTexto.text = "Riesgo"
        categoriaTexto:setFillColor(1,0.3,0.3)
        aguja:setStrokeColor(1,0.3,0.3)

    end

end

-------------------------------------------------
-- LIMPIAR
-------------------------------------------------
local function limpiar()

    peso.text = ""
    altura.text = ""

    textoIMC.text = "--"
    categoriaTexto.text = "Categoría: --"

    aguja.rotation = 0
    aguja:setStrokeColor(1,1,1)

end

-------------------------------------------------
-- BOTONES
-------------------------------------------------
local btnCalcular = display.newText({
    text = "Calcular IMC",
    x = display.contentCenterX,
    y = 570,
    font = native.systemFontBold,
    fontSize = 24
})
btnCalcular:setFillColor(0.3,0.6,1)
btnCalcular:addEventListener("tap", calcularIMC)

local btnLimpiar = display.newText({
    text = "Limpiar",
    x = display.contentCenterX,
    y = 640,
    font = native.systemFontBold,
    fontSize = 22
})
btnLimpiar:setFillColor(0.7,0.7,0.7)
btnLimpiar:addEventListener("tap", limpiar)
