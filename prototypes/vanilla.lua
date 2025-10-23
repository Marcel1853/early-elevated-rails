---@diagnostic disable: undefined-global

-- Verstecke die originale elevated-rail Technologie
if data.raw.technology["elevated-rail"] then
    data.raw.technology["elevated-rail"].enabled = false
    data.raw.technology["elevated-rail"].hidden = true
    data.raw.technology["elevated-rail"].effects = {}
end

-- Stelle sicher dass Elevated Rail Planner verfügbar ist
if data.raw["rail-planner"] and data.raw["rail-planner"]["elevated-rail"] then
    data.raw["rail-planner"]["elevated-rail"].hidden = false
end

-- Füge Elevated Rails Rezepte zur Railway-Technologie hinzu
if data.raw.technology["railway"] then
    local railway_effects = data.raw.technology["railway"].effects or {}

    -- Prüfe ob die Rezepte schon existieren, um Duplikate zu vermeiden
    local has_ramp = false
    local has_support = false
    local has_elevated_rail = false

    for _, effect in pairs(railway_effects) do
        if effect.type == "unlock-recipe" then
            if effect.recipe == "rail-ramp" then has_ramp = true end
            if effect.recipe == "rail-support" then has_support = true end
            if effect.recipe == "elevated-rail" then has_elevated_rail = true end
        end
    end

    -- Füge Rezepte nur hinzu wenn sie noch nicht da sind
    if data.raw.recipe["rail-ramp"] and not has_ramp then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-ramp" })
    end

    if data.raw.recipe["rail-support"] and not has_support then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-support" })
    end

    if data.raw.recipe["elevated-rail"] and not has_elevated_rail then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "elevated-rail" })
    end

    if data.raw["rail-planner"] and data.raw["rail-planner"]["elevated-rail"] then
        data.raw["rail-planner"]["elevated-rail"].hidden = true
    end

    data.raw.technology["railway"].effects = railway_effects
end

-- Passe "Rail planner elevated rails" Technologie an (früher verfügbar)
if data.raw.technology["rail-planner-elevated-rails"] then
    data.raw.technology["rail-planner-elevated-rails"].prerequisites = { "railway" }
    data.raw.technology["rail-planner-elevated-rails"].unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   2 }
        },
        time = 50
    }
end

-- Passe Refined Concrete an - früher verfügbar
if data.raw.technology["refined-concrete"] then
    data.raw.technology["refined-concrete"].prerequisites = { "concrete", "steel-processing" }
    data.raw.technology["refined-concrete"].unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 3 },
            { "logistic-science-pack",   1 }
        },
        time = 50
    }
end
