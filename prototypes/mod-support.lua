---@diagnostic disable: undefined-global

-- ============================================
-- Bob's Logistics Mod Support
-- ============================================
if mods["boblogistics"] then
    -- Verstecke Bob's eigene Elevated Rail Technologie
    if data.raw.technology["bob-elevated-rail"] then
        data.raw.technology["bob-elevated-rail"].enabled = false
        data.raw.technology["bob-elevated-rail"].hidden = true
    end

    -- Füge Bob's Rezepte zur Railway hinzu
    if data.raw.technology["railway"] then
        local railway_effects = data.raw.technology["railway"].effects or {}

        local has_bob_ramp = false
        local has_bob_support = false

        for _, effect in pairs(railway_effects) do
            if effect.type == "unlock-recipe" then
                if effect.recipe == "bob-rail-ramp" then has_bob_ramp = true end
                if effect.recipe == "bob-rail-support" then has_bob_support = true end
            end
        end

        if data.raw.recipe["bob-rail-ramp"] and not has_bob_ramp then
            table.insert(railway_effects, { type = "unlock-recipe", recipe = "bob-rail-ramp" })
        end

        if data.raw.recipe["bob-rail-support"] and not has_bob_support then
            table.insert(railway_effects, { type = "unlock-recipe", recipe = "bob-rail-support" })
        end

        -- FIX: rail-planner-allow-elevated-rails Modifier fehlte in neuen Spielen.
        -- Falls elevated-rail deaktiviert ist, muss der Modifier trotzdem in railway sein.
        local has_rail_planner = false
        for _, effect in pairs(railway_effects) do
            if effect.type == "rail-planner-allow-elevated-rails" then
                has_rail_planner = true
                break
            end
        end
        if not has_rail_planner then
            table.insert(railway_effects, { type = "rail-planner-allow-elevated-rails", modifier = true })
        end

        data.raw.technology["railway"].effects = railway_effects
    end
end

-- FIX (Deep-Sea-Bug): rail-support-foundations hat "elevated-rail" als Voraussetzung.
-- Da elevated-rail durch diesen Mod deaktiviert wird, kann
-- rail-support-foundations sonst nie erforscht werden.
if data.raw.technology["rail-support-foundations"] then
    local prereqs     = data.raw.technology["rail-support-foundations"].prerequisites or {}
    local new_prereqs = {}
    local replaced    = false

    for _, prereq in ipairs(prereqs) do
        if prereq == "elevated-rail" then
            if not replaced then
                local already_has_railway = false
                for _, p in ipairs(prereqs) do
                    if p == "railway" then
                        already_has_railway = true
                        break
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

    if not replaced then
        local already_has_railway = false
        for _, p in ipairs(new_prereqs) do
            if p == "railway" then
                already_has_railway = true
                break
            end
        end
        if not already_has_railway then
            table.insert(new_prereqs, "railway")
        end
    end

    data.raw.technology["rail-support-foundations"].prerequisites = new_prereqs
end

-- ============================================
-- Elevated Rails Mod Support
-- ============================================
if mods["elevated-rails"] then
    -- Diese Mod überschreibt die elevated-rails Mod
    -- Stelle sicher, dass unsere Änderungen Priorität haben

    -- Nochmal sicherstellen, dass elevated-rail versteckt ist
    if data.raw.technology["elevated-rail"] then
        data.raw.technology["elevated-rail"].enabled = false
        data.raw.technology["elevated-rail"].hidden = true
    end
end
