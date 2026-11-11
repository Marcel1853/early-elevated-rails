---@diagnostic disable: undefined-global

local tech_util = require("prototypes.tech-util")

-- Bob's Logistics: eigene Hochgleis-Technologie ebenfalls in "railway" aufgehen lassen.
-- Effekte werden allgemein übernommen statt über feste Rezeptnamen – so bleibt es
-- richtig, auch wenn Bob's die Rezepte umbenennt.
if mods["boblogistics"] then
    tech_util.replace_technology("bob-elevated-rail", "railway")
end
