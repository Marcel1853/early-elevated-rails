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

        data.raw.technology["railway"].effects = railway_effects
    end
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