---@diagnostic disable: undefined-global

local tech_util = require("prototypes.tech-util")

-- Die Technologie "elevated-rail" wird versteckt, ihre Effekte (Rampe, Stütze,
-- Gleisplaner-Modifier und was andere Mods ergänzt haben) wandern nach "railway".
-- Alle Verweise darauf werden mit umgebogen:
--   * Voraussetzungen anderer Technologien (z. B. rail-support-foundations aus Space Age,
--     sonst wäre das Bauen auf Fulgoras Öl-Ozean nie freizuschalten)
--   * Shortcut "Hohe Objekte ein/aus" (technology_to_unlock)
--   * Tipps & Tricks "Hochgleise" (research-Trigger)
tech_util.replace_technology("elevated-rail", "railway")

-- "rail-planner-elevated-rails" gibt es in Vanilla nicht, nur in manchen Mods:
-- dann früher verfügbar machen (rot + grün).
local planner = data.raw.technology["rail-planner-elevated-rails"]
if planner then
    planner.prerequisites = { "railway" }
    planner.unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   2 },
        },
        time = 50,
    }
end

-- Eigene Technologie "refined-concrete" gibt es in Factorio 2.1 nicht mehr (Stahlbeton
-- kommt mit "concrete"). Manche Mods bringen sie zurück: dann früher verfügbar machen.
local refined = data.raw.technology["refined-concrete"]
if refined then
    refined.prerequisites = { "concrete", "steel-processing" }
    refined.unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 3 },
            { "logistic-science-pack",   1 },
        },
        time = 50,
    }
end
