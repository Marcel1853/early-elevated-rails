---@diagnostic disable: undefined-global

-- Stelle sicher dass Elevated Rails immer verfügbar sind (nicht versteckt)
if data.raw["rail-planner"] and data.raw["rail-planner"]["elevated-rail"] then
    data.raw["rail-planner"]["elevated-rail"].hidden = false
end

-- Füge Elevated Rails direkt zur Railway-Technologie hinzu
if data.raw.technology["railway"] then
    -- Füge alle Elevated Rail Rezepte zur Railway-Technologie hinzu
    local railway_effects = data.raw.technology["railway"].effects or {}

    -- Prüfe welche Rezepte existieren und füge sie hinzu
    if data.raw.recipe["rail-ramp"] then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-ramp" })
    end

    if data.raw.recipe["rail-support"] then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-support" })
    end

    data.raw.technology["railway"].effects = railway_effects
end

-- Passe die "Rail planner elevated rails" Technologie an (früher verfügbar)
if data.raw.technology["rail-planner-elevated-rails"] then
    data.raw.technology["rail-planner-elevated-rails"].prerequisites = { "railway" }
    data.raw.technology["rail-planner-elevated-rails"].unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 }
        },
        time = 30
    }
end

-- Entferne die separate Elevated Rail Technologie
--if data.raw.technology["elevated-rail"] then
--    data.raw.technology["elevated-rail"].enabled = false
--    data.raw.technology["elevated-rail"].hidden = true
--end
--
---- Falls Bob's Mods installiert ist, verstecke auch Bob's Elevated Rail Technologie
--if mods["boblogistics"] and data.raw.technology["bob-elevated-rail"] then
--    data.raw.technology["bob-elevated-rail"].enabled = false
--    data.raw.technology["bob-elevated-rail"].hidden = true
--end

-- Passe Refined Concrete (Stahlbeton) an - früher verfügbar
if data.raw.technology["refined-concrete"] then
    data.raw.technology["refined-concrete"].prerequisites = { "concrete", "steel-processing" }
    data.raw.technology["refined-concrete"].unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 }
        },
        time = 30
    }
end
