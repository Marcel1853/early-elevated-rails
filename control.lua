-- Bestehende Spielstände nachziehen: Factorio wendet neue Effekte einer bereits
-- erforschten Technologie nicht von selbst an. Wer "railway" schon erforscht hat, als
-- dieser Mod (oder eine neue Version) dazukam, bekäme sonst weder Rampe/Stütze noch
-- das Umschalten auf Hochgleise im Gleisplaner (G).
--
-- Die Effekte werden aus dem Prototyp gelesen statt aus einer festen Liste – so sind
-- auch Rezepte aus Bob's oder anderen Mods abgedeckt.

local TECHNOLOGY = "railway"

local function apply_effects(force, effects)
    for _, effect in pairs(effects) do
        if effect.type == "unlock-recipe" then
            local recipe = force.recipes[effect.recipe]
            if recipe then recipe.enabled = true end
        elseif effect.type == "rail-planner-allow-elevated-rails" then
            force.rail_planner_allow_elevated_rails = true
        end
    end
end

local function migrate_all_forces()
    local prototype = prototypes.technology[TECHNOLOGY]
    if not prototype then return end
    for _, force in pairs(game.forces) do
        local tech = force.technologies[TECHNOLOGY]
        if tech and tech.researched then
            apply_effects(force, prototype.effects)
        end
    end
end

-- Bei jeder Änderung (Mod neu, Update, andere Mods geändert): kann die Effekte von
-- "railway" verändern. Das Nachziehen ist idempotent und kostet nur einmal beim Laden.
script.on_configuration_changed(migrate_all_forces)
