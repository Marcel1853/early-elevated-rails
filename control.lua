---@diagnostic disable: undefined-global

-- Rezepte die durch diesen Mod via "railway" freigeschaltet werden sollen
local ELEVATED_RECIPES = {
    "rail-ramp",
    "rail-support",
    "elevated-rail",
}

-- Stellt sicher dass alle elevated-rail Rezepte bei einer Force aktiv sind,
-- wenn railway ODER elevated-rail (alter Stand vor dem Mod) bereits erforscht ist.
-- Wird bei on_configuration_changed gebraucht, damit bestehende Saves nicht
-- plötzlich fehlende Rezepte haben.
local function migrate_force(force)
    -- Nur Forces mit eigenem Forschungsbaum (Spieler-Forces)
    if not force.technologies then return end

    local railway_tech = force.technologies["railway"]
    local elevated_tech = force.technologies["elevated-rail"]

    local has_access = (railway_tech  and railway_tech.researched)
                    or (elevated_tech and elevated_tech.researched)

    if not has_access then return end

    for _, recipe_name in ipairs(ELEVATED_RECIPES) do
        local recipe = force.recipes[recipe_name]
        if recipe then
            recipe.enabled = true
        end
    end
end

-- Läuft wenn Mods hinzugefügt, entfernt oder aktualisiert werden.
-- Stellt sicher dass bestehende Saves korrekt migriert werden.
script.on_configuration_changed(function(event)
    -- Nur wenn unser Mod sich geändert hat (Erstinstallation oder Update)
    local our_change = event.mod_changes and event.mod_changes["early-elevated-rails"]
    if not our_change then return end

    for _, force in pairs(game.forces) do
        migrate_force(force)
    end
end)
