---@diagnostic disable: undefined-global

-- Verstecke die originale elevated-rail Technologie und leere ihre Effects.
-- WICHTIG: Wir müssen weiter unten rail-support-foundations reparieren,
-- weil die elevated-rail als Voraussetzung dort drin steckt.
if data.raw.technology["elevated-rail"] then
    data.raw.technology["elevated-rail"].enabled = false
    data.raw.technology["elevated-rail"].hidden = true
    data.raw.technology["elevated-rail"].effects = {}
end

-- Füge Elevated-Rails-Rezepte und Rail-Planner-Modifier zur Railway-Technologie hinzu
if data.raw.technology["railway"] then
    local railway_effects   = data.raw.technology["railway"].effects or {}

    -- Vorhandene Effects prüfen, um Duplikate zu vermeiden
    local has_ramp          = false
    local has_support       = false
    local has_elevated_rail = false
    local has_rail_planner  = false

    for _, effect in pairs(railway_effects) do
        if effect.type == "unlock-recipe" then
            if effect.recipe == "rail-ramp" then has_ramp = true end
            if effect.recipe == "rail-support" then has_support = true end
            if effect.recipe == "elevated-rail" then has_elevated_rail = true end
        end
        if effect.type == "rail-planner-allow-elevated-rails" then
            has_rail_planner = true
        end
    end

    if data.raw.recipe["rail-ramp"] and not has_ramp then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-ramp" })
    end
    if data.raw.recipe["rail-support"] and not has_support then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "rail-support" })
    end
    if data.raw.recipe["elevated-rail"] and not has_elevated_rail then
        table.insert(railway_effects, { type = "unlock-recipe", recipe = "elevated-rail" })
    end

    -- FIX: elevated-rail tech wird deaktiviert und mit ihr der rail-planner-allow-elevated-rails
    -- Modifier. Deshalb muss der Modifier jetzt in railway stecken, sonst funktioniert
    -- das G-Umschalten im Rail Planner nie.
    if not has_rail_planner then
        table.insert(railway_effects, { type = "rail-planner-allow-elevated-rails", modifier = true })
    end

    data.raw.technology["railway"].effects = railway_effects
end

-- Passe "Rail planner elevated rails" Technologie an – früher verfügbar.
-- Diese Tech existiert nur in Bob's Mods o.ä., nicht in Vanilla.
if data.raw.technology["rail-planner-elevated-rails"] then
    data.raw.technology["rail-planner-elevated-rails"].prerequisites = { "railway" }
    data.raw.technology["rail-planner-elevated-rails"].unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   2 },
        },
        time = 50,
    }
end

-- FIX (Deep-Sea-Bug): rail-support-foundations hat "elevated-rail" als Voraussetzung.
-- Da elevated-rail jetzt deaktiviert ist, kann rail-support-foundations nie erforscht
-- werden → Deep-Oil-Ocean-Placement auf Fulgora ist dauerhaft gesperrt.
-- Lösung: "elevated-rail" durch "railway" ersetzen.
if data.raw.technology["rail-support-foundations"] then
    local prereqs     = data.raw.technology["rail-support-foundations"].prerequisites or {}
    local new_prereqs = {}
    local replaced    = false

    for _, prereq in ipairs(prereqs) do
        if prereq == "elevated-rail" then
            -- Einmalig ersetzen, kein Duplikat einfügen wenn railway schon drin ist
            if not replaced then
                -- Nur einfügen wenn railway nicht schon vorhanden
                local already_has_railway = false
                for _, p in ipairs(prereqs) do
                    if p == "railway" then
                        already_has_railway = true; break
                    end
                end
                if not already_has_railway then
                    table.insert(new_prereqs, "railway")
                end
                replaced = true
            end
        else
            table.insert(new_prereqs, prereq)
        end
    end

    -- Fallback: falls elevated-rail nie in der Liste stand, railway trotzdem sichern
    if not replaced then
        local already_has_railway = false
        for _, p in ipairs(new_prereqs) do
            if p == "railway" then
                already_has_railway = true; break
            end
        end
        if not already_has_railway then
            table.insert(new_prereqs, "railway")
        end
    end

    data.raw.technology["rail-support-foundations"].prerequisites = new_prereqs
end

-- Passe Refined Concrete an – früher verfügbar
if data.raw.technology["refined-concrete"] then
    data.raw.technology["refined-concrete"].prerequisites = { "concrete", "steel-processing" }
    data.raw.technology["refined-concrete"].unit = {
        count = 150,
        ingredients = {
            { "automation-science-pack", 3 },
            { "logistic-science-pack",   1 },
        },
        time = 50,
    }
end
